
import 'package:zpass/modules/home/provider/home_provider.dart';
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
    await _doSync(changedEntities);
    await postSync();
  }

  List<T> getChanged(Map<String, T> remoteMap, Map<String, T> localMap) {
    var changed = <T>[];
    remoteMap.forEach((key, remoteEntity) {
      var localEntity = localMap[key];
      if (localEntity == null) {
        changed.add(remoteEntity);
        return ;
      }

      T? mergedEntity = getMergedEntity(remoteEntity, localEntity);
      if (mergedEntity != null) {
        changed.add(mergedEntity);
      }
    });

    return changed;
  }

  ///
  /// Empty method, override in VaultTableSyncUnit
  ///
  Future<void> postSync() {
    return Future.value();
  }

  ///
  /// 1. detect entity exist ro not according to record id;
  ///    add the entity to local if it's just exist in remote;
  ///    add the entity to remote if it's just exist in local;
  /// 2. if entity exist in both local and remote, update it with the newer updateTime one;
  /// 3. if entity is marked delete either in local or remote, mark delete on both side;
  /// 4. the priority of restoreTime is higher than updateTime;
  ///    update both side with the newer restoreTime one;
  ///    check updateTime and isDeleted just restoreTime is the same;
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

    for (var entity in changedEntities) {
      final putRet = await HomeProvider().repoDB.raw.put(entity);
      Log.d("entity ${entity.getEntityKey()} put result: $putRet", tag: "BaseTableSyncUnit");
    }
    final flushRet = await HomeProvider().repoDB.raw.flush();
    Log.d("db instance flush result: $flushRet", tag: "BaseTableSyncUnit");
  }
}