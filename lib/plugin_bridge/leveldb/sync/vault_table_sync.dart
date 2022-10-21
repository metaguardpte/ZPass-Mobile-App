
import 'dart:math';

import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';
import 'package:zpass/plugin_bridge/leveldb/query_context.dart';
import 'package:zpass/plugin_bridge/leveldb/sync/db_sync.dart';
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
    var maxUseTime = getMax(latestUseTime, sourceUseTime);
    latest.useTime = maxUseTime;
  }

  int? getMax(int? num1, int? num2) {
    if (num1 == null) {
      return num2;
    }
    if (num2 == null) {
      return num1;
    }
    return max(num1, num2);
  }

  ///
  /// VaultItem的Login类型需要进行去重，去重策略如下：
  /// 1. 根据Login的loginUri和loginUser来判断是否存在重复的记录
  /// 2. 存在重复记录的话，根据updateTime取最新的那条记录
  /// 3. 如果字段oneTimePassword在重复的多条记录中都有值，取updateTime最新的记录，如果oneTimePassword新的记录没有值，但旧的记录有值，把值赋到新的记录中。
  /// 4. 合并重复记录的tag字段，该字段是字符串数组，值不重复。
  ///
  @override
  void deleteDuplicateEntities() {
    QueryContext queryContext = QueryContext("", EntityType.vaultItem, VaultItemType.login, SortBy.createTime);
    var logins = ZPassDB().listVaultItemEntity(queryContext);
    var uniqueToLogins = _groupByLoginUnique(logins);

    var changed = <VaultItemEntity>[];
    uniqueToLogins.forEach((key, entities) {
      var length = entities.length;
      if (length < 2) {
        return;
      }

      _updateOneTimePasswordIfNecessary(entities);
      changed.addAll(entities);
    });
  }

  Map<String, List<VaultItemEntity>> _groupByLoginUnique(List<VaultItemEntity> logins) {
    return <String, List<VaultItemEntity>>{};
  }

  void _updateOneTimePasswordIfNecessary(List<VaultItemEntity> entities) {
    //sort by update time desc
    entities.sort((a, b) => b.updateTime.compareTo(a.updateTime));
  }

  ///
  /// Login 唯一标识生成逻辑参考PC版现有逻辑
  /// https://github.com/metaguardpte/ZPassApp/blob/4ef376f1493682a80b43f2ed642152acf343d3f5/render/src/utils/loginUnique.ts#L44
  ///
  String _generateLoginUnique(String url, String username) {
    var lowerUrl = url.toLowerCase();
    var lowerUsername = username.toLowerCase();
    if (!lowerUrl.startsWith('http') && !lowerUrl.startsWith('https')) {
      lowerUrl = "http://$lowerUrl";
    }

    try {
      var domainName = Uri.parse(lowerUrl).host;
      return "$domainName-$lowerUsername";
    } catch (e) {
      Log.e("Error parsing url: $lowerUrl, msg: ${e.toString()}");
    }
    return "$url-$lowerUsername";
  }
}