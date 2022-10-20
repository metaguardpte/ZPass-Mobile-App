import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/home/repo/repo_base.dart';
import 'package:zpass/plugin_bridge/leveldb/query_context.dart';
import 'package:zpass/plugin_bridge/leveldb/zpass_db.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zpass/util/log_utils.dart';

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
    return _db.list(entityType);
  }

  @override
  List<VaultItemEntity> query(QueryContext queryContext) {
    return _db.listVaultItemEntity(queryContext);
  }

  @override
  Future<bool> flush() {
    // TODO: implement flush
    throw UnimplementedError();
  }

  @override
  Future init() async {
    final dir = await getApplicationSupportDirectory();
    Log.d("leveldb dir: $dir", tag: "RepoDB");
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