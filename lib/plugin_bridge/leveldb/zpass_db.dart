import 'dart:convert';
import 'dart:typed_data';

import 'package:flkv/flkv.dart';
import 'package:path/path.dart';
import 'package:collection/collection.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zpass/modules/home/model/vault_item_entity.dart';

import 'record_entity.dart';

class ZPassDB {
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

  List<E> list<E extends RecordEntity>() {
    List<Record> records = _db.list();
    var entities = <E>[];
    for (var record in records) {
      var key = record.key;
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
  /// 分组
  ///   createTime, updateTime
  ///   今天用，昨天用，本周，具体月
  ///
  void groupBy<E extends RecordEntity>(String sortBy) {
    throw UnsupportedError("groupBy unsupported");
  }

  Future<void> open() async {
    final applicationDocDir = await getTemporaryDirectory();
    var dbPath = join(applicationDocDir.path, "zpass");
    print("open db ..................");
    _db = KvDB.open(dbPath);
  }

  void close() {
    _db.close();
  }

  Uint8List _toUint8List(String src) {
    return Uint8List.fromList(utf8.encode(src));
  }

  String _toSting(Uint8List uint8list) {
    return utf8.decode(uint8list);
  }

  ///
  /// TODO return entity base on the key
  ///
  E? _toEntity<E extends RecordEntity>(String key, String jsonStr) {
    Map<String, dynamic> jsonMap = jsonDecode(jsonStr);
    VaultItemEntity entity = VaultItemEntity.fromJson(jsonMap);
    return entity as E;
  }
}
