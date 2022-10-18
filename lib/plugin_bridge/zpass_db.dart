import 'dart:convert';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

import 'package:flkv/flkv.dart';

class ZPass {
  late KvDB db;

  bool put(String? key, String? value) {
    if (key == null || key.isEmpty) {
      return false;
    }

    if (value == null || value.isEmpty) {
      return false;
    }

    Uint8List keyUint8List = _toUint8List(key);
    Uint8List valueUint8List = _toUint8List(value);
    return this.db.put(keyUint8List, valueUint8List);
  }

  String? get(String? key) {
    if (key == null || key.isEmpty) {
      return null;
    }

    var keyUint8List = _toUint8List(key);
    var valueUintList = this.db.get(keyUint8List);
    if (valueUintList == null) {
      return null;
    }

    return _toSting(valueUintList);
  }

  bool delete(String? key) {
    if (key == null || key.isEmpty) {
      return false;
    }

    var uint8list = _toUint8List(key);
    return this.db.delete(uint8list);
  }

  List<Record> list() {
    return this.db.list();
  }

  void close() {
    this.db.close();
  }

  void open() async {
    final applicationDocDir = await getTemporaryDirectory();
    var dbPath = join(applicationDocDir.path, "zpass");
    this.db = KvDB.open(dbPath);
  }

  Uint8List _toUint8List(String src) {
    return Uint8List.fromList(utf8.encode(src));;
  }

  String _toSting(Uint8List uint8list) {
    return utf8.decode(uint8list);
  }
}
