import 'dart:convert';

import 'package:flkv/flkv.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';
import 'package:zpass/plugin_bridge/leveldb/query_context.dart';
import 'package:zpass/util/log_utils.dart';

import 'record_entity.dart';

///
/// Singleton
///
class ZPassDB {

  ZPassDB._();

  static final ZPassDB _instance = ZPassDB._();

  factory ZPassDB(){
    return _instance;
  }

  bool _opened = false;
  late LevelDB _db;

  Future<bool> put<E extends RecordEntity> (E entity) async {
    String key = entity.getEntityKey();
    if (key.isEmpty) {
      return false;
    }

    String value = entity.getEntityValue();
    if (value.isEmpty) {
      return false;
    }

    return _db.put(key, value);
  }

  Future<E?> get<E extends RecordEntity>(String? key) async {
    if (key == null || key.isEmpty) {
      return null;
    }

    var value = await _db.get(key);
    if (value == null) {
      return null;
    }

    return _toEntity(key, value);
  }

  Future<bool> delete(String? key) async {
    if (key == null || key.isEmpty) {
      return false;
    }

    return _db.delete(key);
  }

  Future<List<E>> list<E extends RecordEntity>(EntityType type) async {
    List<Record> records = await _db.list();
    var typeName = type.name;
    var entities = <E>[];
    for (var record in records) {
      var key = record.key;
      if (!key.contains(typeName)) {
        continue;
      }
      var jsonStr = record.value;
      var entity = _toEntity(key, jsonStr) as E?;
      if (entity == null) {
        continue;
      }
      entities.add(entity);
    }
    return entities;
  }

  ///
  /// sort by : createTime, updateTime
  ///
  /// group by: today, yesterday, week, month, null
  ///
  Future<List<VaultItemEntity>> listVaultItemEntity(QueryContext queryContext) async {
    var entityType = queryContext.entityType;
    if (entityType != EntityType.vaultItem) {
      return <VaultItemEntity>[];
    }

    var keyword = queryContext.keyword;
    var records = await list(entityType);
    var entities = <VaultItemEntity>[];
    for (var rec in records) {
      var entity = rec as VaultItemEntity;
      entities.add(entity);
    }

    var itemType = queryContext.itemType;
    entities = entities.where((element) => _filter(element, keyword, itemType)).toList();

    var sortBy = queryContext.sortBy;
    entities.sort((a, b) => _sort(a, b, sortBy));
    return entities;
  }

  Future<bool> flush() async {
    return _db.flush();
  }

  Future<void> open({String path=""}) async {
    if (!_opened) {
      var dbPath = path;
      if (dbPath.isEmpty) {
        final applicationDocDir = await getTemporaryDirectory();
        dbPath = join(applicationDocDir.path, "zpass");
      }
      if (!_opened) {
        Log.d("open db with path: $dbPath");
        _db = LevelDB(dbPath);
        await _db.open();
        _opened = true;
      }
    }
  }

  void close() async {
    if (_opened) {
      Log.d("Close db");
      var closeResult = await _db.close();
      Log.d("close result:: $closeResult");
      _opened = false;
    }
  }

  Future<List<E>> tempReadRemote<E extends RecordEntity>(String remoteDBPath, EntityType type) async {
    var tempDB = LevelDB(remoteDBPath);
    await tempDB.open();
    List<Record> records = await tempDB.list();
    tempDB.close();
    var typeName = type.name;
    var entities = <E>[];
    for (var record in records) {
      var key = record.key;
      if (!key.contains(typeName)) {
        continue;
      }
      var jsonStr = record.value;
      var entity = _toEntity(key, jsonStr) as E?;
      if (entity == null) {
        continue;
      }
      entities.add(entity);
    }
    return entities;
  }

  String getDBPath() {
    return _db.getPath();
  }

  bool _filter(VaultItemEntity entity, String keyword, VaultItemType itemType) {
    var type = entity.type;
    bool typeMatched = (type==itemType.index);
    if (!typeMatched) {
      return false;
    }

    if (keyword.isEmpty) {
      return true;
    }

    var name = entity.name;
    return name.contains(keyword);
  }

  int _sort(VaultItemEntity thisEntity, VaultItemEntity anotherEntity, SortBy sortBy) {
    int? thisTime;
    int? anotherTime;
    if (sortBy == SortBy.useTime) {
      thisTime = thisEntity.useTime;
      anotherTime = anotherEntity.useTime;
    }
    if (sortBy == SortBy.createTime) {
      thisTime = thisEntity.createTime;
      anotherTime = anotherEntity.createTime;
    }

    if (thisTime==null && anotherTime==null) {
      return 0;
    }

    if (thisTime==null) {
      return -1;
    }

    if (anotherTime==null) {
      return 1;
    }

    if (thisTime == anotherTime) {
      return 0;
    }

    if (thisTime > anotherTime)  {
      return 1;
    }

    return -1;
  }

  E? _toEntity<E extends RecordEntity>(String key, String jsonStr) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
    VaultItemEntity entity = VaultItemEntity.fromJson(jsonMap);
    return entity as E;
  }
}
