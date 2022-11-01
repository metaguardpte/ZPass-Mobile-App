import 'package:zpass/modules/home/model/vault_item_wrapper.dart';
import 'package:zpass/modules/home/provider/home_provider.dart';
import 'package:zpass/modules/home/provider/tab_base_provider.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';
import 'package:zpass/modules/home/repo/repo_db.dart';
import 'package:zpass/plugin_bridge/leveldb/groups.dart';
import 'package:zpass/plugin_bridge/leveldb/query_context.dart';
import 'package:zpass/util/log_utils.dart';

class TabVaultItemProvider extends TabBaseProvider<VaultItemWrapper> {
  final VaultItemType type;
  late final RepoDB _repoDB;

  TabVaultItemProvider({required this.type}) {
    _repoDB = HomeProvider().repoDB;
  }

  @override
  Future<void> init() => _repoDB.init();

  @override
  VaultItemType get dataType => type;

  @override
  Future<void> fetchData({bool reset = false, String keyword = ""}) async {
    loading = true;
    var queryContext = QueryContext(keyword, EntityType.vaultItem, type, SortBy.values[sortType.index]);
    // query from db
    var entities = await _repoDB.query(queryContext);
    Log.d("fetchData entities count: ${entities.length}");
    // grouping
    var entityGroups = Groups.grouping(entities, queryContext.sortBy);
    // adapt the entity groups
    var wrappers = <VaultItemWrapper>[];
    for (var group in entityGroups) {
      wrappers.addAll(group.entities.map(
          (e) => VaultItemWrapper(raw: e, groupName: group.name)..decrypt()));
    }
    // update data source
    dataSource = wrappers;
    loading = false;
  }

  @override
  Future<void> filterData({required String keyword}) async {
    // TODO: implement filterData
    Log.d("filterData, keyword: $keyword", tag: "TabVaultItemProvider");
    fetchData(reset: true, keyword: keyword);
  }

  @override
  Future<void> loadMoreData({int count = 100}) async {
    // TODO: implement loadMoreData
  }

  @override
  void dispose() {
    super.dispose();
  }
}