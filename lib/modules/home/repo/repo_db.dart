import 'dart:io';

import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/home/repo/repo_base.dart';
import 'package:zpass/modules/user/user_provider.dart';
import 'package:zpass/plugin_bridge/leveldb/query_context.dart';
import 'package:zpass/plugin_bridge/leveldb/zpass_db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zpass/util/log_utils.dart';

class RepoDB extends RepoBase<VaultItemEntity> {

  late ZPassDB _db;
  ZPassDB get raw => _db;

  @override
  Future<bool> add(VaultItemEntity item) {
    return _db.put(item);
  }

  @override
  bool addAll(List<VaultItemEntity> items) {
    // TODO: implement addAll
    throw UnimplementedError();
  }

  @override
  Future<List<VaultItemEntity>> query(QueryContext queryContext) async {
    return _db.listVaultItemEntity(queryContext);
  }

  @override
  Future<bool> flush() {
    return _db.flush();
  }

  @override
  Future init() async {
    final dir = await getApplicationSupportDirectory();
    final userId = UserProvider().profile.data.userId;
    final userDBDir = "${dir.path}/$userId";
    Directory(userDBDir).createSync(recursive: true);//make sure all dirs are exist
    Log.d("leveldb dir: $userDBDir", tag: "RepoDB");
    _db = ZPassDB();
    return _db.open(path: "$userDBDir/leveldb");
  }

  @override
  Future<bool> remove(VaultItemEntity item) {
    return _db.softDelete(item.getEntityKey());
  }

  @override
  bool removeBy(String condition) {
    // TODO: implement removeBy
    throw UnimplementedError();
  }

  @override
  Future<bool> update(VaultItemEntity item) {
    return _db.put(item);
  }

  @override
  void close() {
    _db.close();
  }
}