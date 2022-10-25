import 'dart:convert';
import 'dart:typed_data';

import 'package:flkv/flkv.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';
import 'package:zpass/modules/home/model/password_history_entity.dart';
import 'package:zpass/modules/home/model/address_entity.dart';
import 'package:zpass/modules/home/model/token_collection_entity.dart';
import 'package:zpass/modules/home/model/token_multi_send_entity.dart';
import 'package:zpass/modules/home/model/token_info_entity.dart';
import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';
import 'package:zpass/plugin_bridge/leveldb/query_context.dart';
import 'package:zpass/util/log_utils.dart';

import 'record_entity.dart';

///
/// 单例
///
class ZPassDB {

  ZPassDB._privateConstructor();

  static final ZPassDB _instance = ZPassDB._privateConstructor();
  static final Lock lock = Lock(reentrant:true);

  factory ZPassDB(){
    return _instance;
  }

  bool _opened = false;
  String _dbPath = "";
  late KvDB _db;

  bool put<E extends RecordEntity> (E entity) {
    String key = entity.getEntityKey();
    if (key.isEmpty) {
      return false;
    }

    String value = entity.getEntityValue();
    if (value.isEmpty) {
      return false;
    }

    Uint8List keyUint8List = _toUint8List(key);
    Uint8List valueUint8List = _toUint8List(value);
    return _db.put(keyUint8List, valueUint8List);
  }

  E? get<E extends RecordEntity>(String? key) {
    if (key == null || key.isEmpty) {
      return null;
    }

    var keyUint8List = _toUint8List(key);
    var valueUintList = _db.get(keyUint8List);
    if (valueUintList == null) {
      return null;
    }

    String jsonStr = _toSting(valueUintList);
    return _toEntity(key, jsonStr);
  }

  bool delete(String? key) {
    if (key == null || key.isEmpty) {
      return false;
    }

    var uint8list = _toUint8List(key);
    return _db.delete(uint8list);
  }

  List<E> list<E extends RecordEntity>(EntityType type) {
    List<Record> records = _db.list();
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
  /// 根据sortBy字段
  ///   sort by : createTime, updateTime
  ///
  /// 按下面四个维度分组
  ///   group by: today, yesterday, week, month, null
  ///
  List<VaultItemEntity> listVaultItemEntity(QueryContext queryContext) {
    var entityType = queryContext.entityType;
    if (entityType != EntityType.vaultItem) {
      return <VaultItemEntity>[];
    }

    var keyword = queryContext.keyword;
    var records = list(entityType);
    var entities = <VaultItemEntity>[];
    for (var rec in records) {
      var entity = rec as VaultItemEntity;
      entities.add(entity);
    }

    var itemType = queryContext.itemType;
    var includeDeleted = queryContext.includeDeleted;
    entities = entities.where((element) => _filter(element, keyword, itemType, includeDeleted)).toList();

    var sortBy = queryContext.sortBy;
    entities.sort((a, b) => _sort(a, b, sortBy));
    return entities;
  }

  ///
  /// 需要保证线程安全
  ///
  Future<void> open({String path=""}) async {
    if (!_opened) {
      var dbPath = path;
      if (dbPath.isEmpty) {
        final applicationDocDir = await getTemporaryDirectory();
        dbPath = join(applicationDocDir.path, "zpass");
      }
      lock.synchronized(() {
        if (!_opened) {
          Log.d("open db with path: $dbPath");
          _db = KvDB.open(dbPath);
          _opened = true;
          _dbPath = dbPath;
        }
      });
    }
  }

  ///
  /// 需要保证线程安全
  ///
  void close() {
    if (_opened) {
      lock.synchronized(() {
        Log.d("Close db");
        _db.close();
        _opened = false;
        _dbPath = "";
      });
    }
  }

  String getDBPath() {
    return _dbPath;
  }

  bool _filter(VaultItemEntity entity, String keyword, VaultItemType itemType, bool includeDeleted) {
    var type = entity.type;
    bool typeMatched = (type==itemType.index);
    if (!typeMatched) {
      return false;
    }

    bool isDeleted = entity.isDeleted;
    if (isDeleted && !includeDeleted) {
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

  Uint8List _toUint8List(String src) {
    return Uint8List.fromList(utf8.encode(src));
  }

  String _toSting(Uint8List uint8list) {
    return utf8.decode(uint8list);
  }

  E? _toEntity<E extends RecordEntity>(String key, String jsonStr) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
    if (key.contains(EntityType.vaultItem.name)) {
      return VaultItemEntity.fromJson(jsonMap) as E;
    }
    if (key.contains(EntityType.passwordHistory.name)) {
      return PasswordHistoryEntity.fromJson(jsonMap) as E;
    }
    if (key.contains(EntityType.address.name)) {
      return AddressEntity.fromJson(jsonMap) as E;
    }
    if (key.contains(EntityType.tokenCollection.name)) {
      return TokenCollectionEntity.fromJson(jsonMap) as E;
    }
    if (key.contains(EntityType.tokenMultiSend.name)) {
      return TokenMultiSendEntity.fromJson(jsonMap) as E;
    }
    if (key.contains(EntityType.tokenInfo.name)) {
      return TokenInfoEntity.fromJson(jsonMap) as E;
    }
    return null;
  }
}
