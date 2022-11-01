
import 'package:zpass/plugin_bridge/leveldb/query_context.dart';
import 'package:zpass/plugin_bridge/leveldb/record_entity.dart';
import 'package:zpass/plugin_bridge/leveldb/zpass_db.dart';
import 'package:zpass/util/log_utils.dart';


class BaseTableSyncUnit<T extends RecordEntity> {
  EntityType entityType;

  BaseTableSyncUnit(this.entityType);

  Future<void> sync(String remoteDBPath) async {
    var remoteRecords = await ZPassDB().tempReadRemote(remoteDBPath, entityType);
    var localRecords = await ZPassDB().list(entityType);
    Log.d(
        "entity-type: $entityType, sync remoteRecords: ${remoteRecords.length}, localRecords: ${localRecords.length}",
        tag: "BaseTableSyncUnit");

    var remoteMap = _toMap(_convertListType(remoteRecords));
    var localMap = _toMap(_convertListType(localRecords));

    var changedEntities = getChanged(remoteMap, localMap);
    Log.d("changedEntities: ${changedEntities.length}",
        tag: "BaseTableSyncUnit");
    _doSync(changedEntities);
    postSync();
    return;
  }

  List<T> getChanged(Map<String, T> remoteMap, Map<String, T> localMap) {
    var changed = <T>[];
    remoteMap.forEach((key, remoteEntity) {
      var localEntity = localMap[key];
      if (localEntity == null) {
        changed.add(remoteEntity);
        return ;
      }

      T? mergedEntity = getMergedEntity(remoteEntity, localEntity!);
      if (mergedEntity != null) {
        changed.add(mergedEntity);
      }
    });

    return changed;
  }

  ///
  /// Empty method, override in VaultTableSyncUnit
  ///
  void postSync() {
  }

  ///
  /// 1. 同步的过程是根据id查找local或者remote中的新entity，如果发现了就新增一条记录，
  /// 比如：再local中没有的记录在remote中发现存在，就在local中新增那条记录。
  // 2. 当两边都存在相同ID的记录时，那就需要使用updateTime来判断那条记录是最新的，使用新的来覆盖旧的记录。
  // 3. 记录在local或者remote被标识为delete的，两边都会标识为delete，而且记录也会根据第二条更新
  // 4. restoreTime的优先级会高于updateTime，如果发现restoreTime的的时间更新后，
  // 直接用restoreTime最新的那条记录覆盖，只有当restoreTime的值一样的情况下才会判断updateTime和isDeleted字段。
  ///
  T? getMergedEntity(T remoteT, T localT) {
    var remoteRestoreTime = remoteT.restoreTime;
    var localRestoreTime = localT.restoreTime;

    if (localRestoreTime == null && remoteRestoreTime != null) {
      return remoteT;
    }
    if (localRestoreTime != null && remoteRestoreTime != null &&
        remoteRestoreTime > localRestoreTime) {
      return remoteT;
    }

    var remoteUpdateTime = remoteT.updateTime;
    var localUpdateTime = localT.updateTime;

    T? latestVersion;
    if (remoteUpdateTime > localUpdateTime) {
      latestVersion = remoteT;
      postMerge(latestVersion, localT);
    }

    if (relativePropsChanged(remoteT, localT)) {
      latestVersion = localT;
      postMerge(latestVersion, remoteT);
    }

    return latestVersion;
  }

  bool relativePropsChanged(T remote, T local) {
    var remoteDeleted = remote.isDeleted;
    var localDeleted = local.isDeleted;
    return (remoteDeleted && !localDeleted);
  }

  void postMerge(T latest, T source) {
    if (source.isDeleted && !latest.isDeleted) {
      latest.isDeleted = true;
    }
  }

  List<T> _convertListType(List<RecordEntity> records) {
    var convertedRecords = <T>[];
    for (var record in records) {
      var converted = record as T;
      convertedRecords.add(converted);
    }
    return convertedRecords;
  }

  Map<String, T> _toMap(List<T> records) {
    var idToRecordMap = <String, T>{};
    for (var record in records) {
      var id = record.getEntityKey();
      idToRecordMap[id] = record;
    }
    return idToRecordMap;
  }

  Future<void> _doSync(List<T> changedEntities) async {
    if (changedEntities.isEmpty) {
      return;
    }

    var dbInstance = ZPassDB();
    for (var entity in changedEntities) {
      final putRet = await dbInstance.put(entity);
      Log.d("entity ${entity.getEntityKey()} put result: $putRet", tag: "BaseTableSyncUnit");
    }
    final flushRet = await dbInstance.flush();
    Log.d("db instance flush result: $flushRet", tag: "BaseTableSyncUnit");
    return;
  }
}