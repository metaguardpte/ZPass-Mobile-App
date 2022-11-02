
import 'package:zpass/modules/sync/db_sync/base_table_sync.dart';
import 'package:zpass/modules/sync/db_sync/vault_table_sync.dart';
import 'package:zpass/plugin_bridge/leveldb/query_context.dart';

///
/// ZPass DB数据同步逻辑； https://fjzx.yuque.com/uesase/kabox2/29715911
///
class DBSyncUnit {
  static Future<void> sync(String remoteDBPath) async {
    var tableSyncUnits = <BaseTableSyncUnit>[
      VaultTableSyncUnit(),
      BaseTableSyncUnit(EntityType.passwordHistory),
      BaseTableSyncUnit(EntityType.address),
      BaseTableSyncUnit(EntityType.tokenCollection),
      BaseTableSyncUnit(EntityType.tokenMultiSend),
      BaseTableSyncUnit(EntityType.tokenInfo),
    ];
    for (var unit in tableSyncUnits) {
      await unit.sync(remoteDBPath);
    }
    return;
  }
}

