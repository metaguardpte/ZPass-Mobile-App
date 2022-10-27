
import 'dart:convert';
import 'dart:math';

import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/home/model/vault_item_login_detail.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';
import 'package:zpass/modules/sync/db_sync/base_table_sync.dart';
import 'package:zpass/plugin_bridge/crypto/crypto_manager.dart';
import 'package:zpass/plugin_bridge/leveldb/query_context.dart';
import 'package:zpass/plugin_bridge/leveldb/zpass_db.dart';
import 'package:zpass/util/log_utils.dart';
import 'package:collection/collection.dart';

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
  void postSync() async {
    QueryContext queryContext = QueryContext("", EntityType.vaultItem, VaultItemType.login, SortBy.createTime);
    var logins = await ZPassDB().listVaultItemEntity(queryContext);
    var uniqueToLogins = groupBy(logins, (login) => _generateLoginUnique(login));

    var changed = <VaultItemEntity>[];
    uniqueToLogins.forEach((key, entities) {
      var length = entities.length;
      var duplicatedNotFound = (length < 2);
      if (duplicatedNotFound) {
        return;
      }
      _updateOneTimePasswordAndTagsIfNecessary(entities);
      changed.addAll(entities);
    });
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

  void _updateOneTimePasswordAndTagsIfNecessary(List<VaultItemEntity> entities) {
    //sort by update time desc
    entities.sort((a, b) => b.updateTime.compareTo(a.updateTime));
  }

  ///
  /// Login unique generation logic reference to:
  /// https://github.com/metaguardpte/ZPassApp/blob/4ef376f1493682a80b43f2ed642152acf343d3f5/render/src/utils/loginUnique.ts#L44
  ///
  Future<String> _generateLoginUnique(VaultItemEntity login) async {
    final detail = VaultItemLoginDetail.fromJson(login.detail);
    var decryptContent = await CryptoManager()
        .decryptText(text: detail.content)
        .catchError((e) {
      Log.e("decrypt login detail content failed: $e");
    });
    if (decryptContent.isEmpty) {
      return "";
    }

    String url = detail.loginUri?? "";
    String username = jsonDecode(decryptContent)["loginUser"];
    var lowerUrl = url.toLowerCase();
    var lowerUsername = username.toLowerCase();
    if (!lowerUrl.startsWith('http') && !lowerUrl.startsWith('https')) {
      lowerUrl = "http://$lowerUrl";
    }

    var domainName = _getDomainName(lowerUrl);
    return "$domainName-$lowerUsername";
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