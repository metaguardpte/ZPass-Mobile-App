import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/home/repo/repo_base.dart';
import 'package:zpass/plugin_bridge/leveldb/entity_type.dart';
import 'package:zpass/plugin_bridge/leveldb/zpass_db.dart';
import 'package:path_provider/path_provider.dart';

class RepoDB extends RepoBase<VaultItemEntity> {

  late ZPassDB _db;

  @override
  bool add(VaultItemEntity item) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  bool addAll(List<VaultItemEntity> items) {
    // TODO: implement addAll
    throw UnimplementedError();
  }

  @override
  List<VaultItemEntity> filterBy(EntityType entityType) {
    print("get db list ...................");
    return _db.list(entityType);
  }

  @override
  Future<bool> flush() {
    // TODO: implement flush
    throw UnimplementedError();
  }

  @override
  Future init() async {
    final dir = await getApplicationSupportDirectory();
    print("dir: $dir");
    _db = ZPassDB();
    return _db.open(path: "${dir.path}/leveldb");
  }

  @override
  bool remove(VaultItemEntity item) {
    // TODO: implement remove
    throw UnimplementedError();
  }

  @override
  bool removeBy(String condition) {
    // TODO: implement removeBy
    throw UnimplementedError();
  }

  @override
  void close() {
    _db.close();
  }
}