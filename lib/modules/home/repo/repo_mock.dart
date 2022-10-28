import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';
import 'package:zpass/modules/home/repo/repo_base.dart';
import 'package:zpass/plugin_bridge/leveldb/query_context.dart';

class RepoMock extends RepoBase<VaultItemEntity> {
  @override
  bool add(VaultItemEntity item) {
    rawData.add(item);
    return true;
  }

  @override
  bool addAll(List<VaultItemEntity> items) {
    rawData.addAll(items);
    return true;
  }

  @override
  Future<List<VaultItemEntity>> query(QueryContext queryContext) {
    return Future.value(<VaultItemEntity>[]);
  }

  List<VaultItemEntity> filterByType(VaultItemType type) {
    return rawData.where((element) => element.type == type.index).toList();
  }

  @override
  Future<bool> flush() {
    return Future.value(true);
  }

  @override
  Future init() {
    int count = 0;
    addAll(List.generate(3, (index) => VaultItemEntity(id: "$index",
        updateTime: DateTime.now().millisecondsSinceEpoch - 1000 * 3600 * 24 * 6,
        createTime: DateTime.now().millisecondsSinceEpoch - 1000 * 3600 * 24 * 6,
        isDeleted: false,
        name: "test--$index",
        description: "test--$index desc",
        detail: "test--$index detail",
        type: VaultItemType.login.index,
        star: false,
        tags: [],
        useTime: DateTime.now().millisecondsSinceEpoch - 1000 * 3600 * 24 * 6)));
    count += 3;
    addAll(List.generate(6, (index) => VaultItemEntity(id: "${count + index}",
        updateTime: DateTime.now().millisecondsSinceEpoch - 1000 * 3600 * 24 * 3,
        createTime: DateTime.now().millisecondsSinceEpoch - 1000 * 3600 * 24 * 3,
        isDeleted: false,
        name: "test--${count + index}",
        description: "test--${count + index} desc",
        detail: "test--${count + index} detail",
        type: VaultItemType.login.index,
        star: false,
        tags: [],
        useTime: DateTime.now().millisecondsSinceEpoch - 1000 * 3600 * 24 * 3)));
    count += 6;
    addAll(List.generate(5, (index) => VaultItemEntity(id: "${count + index}",
        updateTime: DateTime.now().millisecondsSinceEpoch - 1000 * 3600 * 24,
        createTime: DateTime.now().millisecondsSinceEpoch - 1000 * 3600 * 24,
        isDeleted: false,
        name: "test--${count + index}",
        description: "test--${count + index} desc",
        detail: "test--${count + index} detail",
        type: VaultItemType.login.index,
        star: false,
        tags: [],
        useTime: DateTime.now().millisecondsSinceEpoch - 1000 * 3600 * 24)));
    count += 5;
    addAll(List.generate(2, (index) => VaultItemEntity(id: "${count + index}",
        updateTime: DateTime.now().millisecondsSinceEpoch,
        createTime: DateTime.now().millisecondsSinceEpoch,
        isDeleted: false,
        name: "test--${count + index}",
        description: "test--${count + index} desc",
        detail: "test--${count + index} detail",
        type: VaultItemType.login.index,
        star: false,
        tags: [],
        useTime: DateTime.now().millisecondsSinceEpoch)));
    return Future.value(true);
  }

  @override
  bool remove(VaultItemEntity item) {
    return rawData.remove(item);
  }

  @override
  bool removeBy(String condition) {
    rawData.removeWhere((element) => element.tags?.contains(condition) ?? false);
    return true;
  }

  @override
  void close() {

  }
}