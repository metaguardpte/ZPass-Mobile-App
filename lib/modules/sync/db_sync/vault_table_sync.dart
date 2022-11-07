
import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/home/model/vault_item_login_detail.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';
import 'package:zpass/modules/sync/db_sync/base_table_sync.dart';
import 'package:zpass/plugin_bridge/crypto/crypto_manager.dart';
import 'package:zpass/plugin_bridge/leveldb/query_context.dart';
import 'package:zpass/plugin_bridge/leveldb/zpass_db.dart';
import 'package:zpass/util/log_utils.dart';

class VaultTableSyncUnit extends BaseTableSyncUnit<VaultItemEntity> {

  VaultTableSyncUnit() : super(EntityType.vaultItem);

  @override
  bool relativePropsChanged(VaultItemEntity remote, VaultItemEntity local) {
    var changed = super.relativePropsChanged(remote, local);
    if (changed) {
      return true;
    }

    var remoteUseTime = remote.useTime;
    var localUseTime = local.useTime;
    if (localUseTime==null && remoteUseTime!=null) {
      return true;
    }
    if (localUseTime!=null && remoteUseTime!=null && remoteUseTime>localUseTime) {
      return true;
    }
    return false;
  }

  @override
  void postMerge(VaultItemEntity latest, VaultItemEntity source) {
    super.postMerge(latest, source);
    var latestUseTime = latest.useTime;
    var sourceUseTime = source.useTime;
    latest.useTime = _getMax(latestUseTime, sourceUseTime);
  }

  ///
  /// Remove duplicated login records by login unique key
  /// 1. identify the Login entities base on loginUri and loginUser
  /// 2. if duplicated entities found, use the latest one by updateTime
  /// 3. if oneTimePassword property exists in all entities, get value from latest updateTime record.
  ///    if oneTimePassword property is empty in the latest updateTime record, copy the value from old version
  /// 4. Merge tags in all Login entities
  ///
  @override
  Future<void> postSync() async {
    QueryContext queryContext = QueryContext("", EntityType.vaultItem, VaultItemType.login, SortBy.createTime);
    var logins = await ZPassDB().listVaultItemEntity(queryContext);
    var loginWrappers = <LoginEntityWrapper>[];
    for (var login in logins) {
      var wrap = await _toLoginWrapper(login);
      loginWrappers.add(wrap);
    }

    var uniqueToLogins = groupBy(loginWrappers, (u) => u.loginUnique);
    var changed = <VaultItemEntity>[];
    uniqueToLogins.forEach((key, wrappers) {
      //NULL means error decrypt the content, ignore the merge
      if (key == "NULL") {
        return;
      }

      var length = wrappers.length;
      var duplicatedNotFound = (length < 2);
      if (duplicatedNotFound) {
        return;
      }

      _updateOneTimePasswordAndTagsIfNecessary(wrappers);
      for (var w in wrappers) {
        changed.add(w.raw);
      }
    });

    for (var entity in changed) {
      await ZPassDB().put(entity);
    }
  }

  int? _getMax(int? num1, int? num2) {
    if (num1 == null) {
      return num2;
    }
    if (num2 == null) {
      return num1;
    }
    return max(num1, num2);
  }

  ///decrypt content:
  ///{
  /// 	"loginUser": "nn@tempmail.cn",
  /// 	"loginPassword": "abc123!!!",
  /// 	"oneTimePassword": "123",
  /// 	"passwordUpdateTime": "2022-10-27T01:59:55.858Z"
  ///}
  Future<LoginEntityWrapper> _toLoginWrapper(VaultItemEntity raw) async {
    var detail = raw.detail;
    var vaultItemLoginDetail = VaultItemLoginDetail.fromJson(detail);
    var decryptContent = await CryptoManager()
        .decryptText(text: vaultItemLoginDetail.content)
        .catchError((e) {
      Log.e("decrypt login detail content failed: $e");
    });
    var loginUnique = await _generateLoginUnique(vaultItemLoginDetail.loginUri, decryptContent);
    return LoginEntityWrapper(raw, loginUnique, vaultItemLoginDetail, decryptContent);
  }

  ///
  /// Login unique generation logic reference to:
  /// https://github.com/metaguardpte/ZPassApp/blob/4ef376f1493682a80b43f2ed642152acf343d3f5/render/src/utils/loginUnique.ts#L44
  ///
  Future<String> _generateLoginUnique(String? loginUrl, String decryptContent) async {
    if (decryptContent.isEmpty) {
      return "NULL";
    }

    String url = loginUrl?? "";
    var lowerUrl = url.toLowerCase();
    if (!lowerUrl.startsWith('http') && !lowerUrl.startsWith('https')) {
      lowerUrl = "http://$lowerUrl";
    }
    var domainName = _getDomainName(lowerUrl);
    String username = jsonDecode(decryptContent)["loginUser"];
    var lowerUsername = username.toLowerCase();
    return "$domainName-$lowerUsername";
  }

  ///
  /// 1. update oneTimePassword, merge tags for latest version
  /// 2. mark isDelete as true in old version record
  ///
  void _updateOneTimePasswordAndTagsIfNecessary(List<LoginEntityWrapper> wrappers) async {
    var length = wrappers.length;
    if (length < 2) {
      return;
    }

    wrappers.sort((a, b) => b.raw.updateTime.compareTo(a.raw.updateTime));
    var latest = wrappers[0];
    var oneTimePassword = latest.decryptContent["oneTimePassword"];
    var oneTimePasswordChanged = false;
    var tags = <String>{};
    var latestTags = latest.raw.tags;
    if (latestTags != null) {
      tags.addAll(latestTags);
    }

    for (var index=1; index<length; index++) {
      var old = wrappers[index];
      old.raw.isDeleted = true;
      if (oneTimePassword == null) {
        var oldOneTimePassword = old.decryptContent["oneTimePassword"];
        if (oldOneTimePassword != null) {
          oneTimePassword = oldOneTimePassword;
          oneTimePasswordChanged = true;
        }
      }

      var oldTags = old.raw.tags;
      if (oldTags != null) {
        tags.addAll(oldTags);
      }
    }

    //append tags
    if (tags.isNotEmpty) {
      var newTags = <String>[];
      newTags.addAll(tags);
      latest.raw.tags = newTags;
    }

    //update oneTimePassword
    if (oneTimePasswordChanged) {
      var decryptContent = latest.decryptContent;
      decryptContent["oneTimePassword"] = oneTimePassword;
      var jsonStr = jsonEncode(decryptContent);
      var content = await CryptoManager().encryptText(text: jsonStr).catchError((e) {
        Log.e("encrypt login detail content failed: $e");
      });

      if (content.isNotEmpty) {
        latest.vaultItemLoginDetail.content = content;
        latest.raw.detail = jsonEncode(latest.vaultItemLoginDetail);
      }
    }
  }

  String _getDomainName(String lowerUrl) {
    if (lowerUrl.isEmpty) {
      return lowerUrl;
    }

    try {
      return Uri.parse(lowerUrl).host;
    } catch (e) {
      Log.e("Error parsing url: $lowerUrl, msg: ${e.toString()}");
    }

    return lowerUrl;
  }
}

class LoginEntityWrapper {
  VaultItemEntity raw;
  VaultItemLoginDetail vaultItemLoginDetail;
  String loginUnique;
  dynamic decryptContent;

  LoginEntityWrapper(this.raw, this.loginUnique, this.vaultItemLoginDetail, this.decryptContent);
}