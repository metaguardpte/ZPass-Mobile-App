import 'package:zpass/modules/home/model/vault_item_wrapper.dart';
import 'package:zpass/modules/home/provider/tab_base_provider.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';
import 'package:zpass/modules/home/repo/repo_db.dart';
import 'package:zpass/plugin_bridge/leveldb/groups.dart';
import 'package:zpass/plugin_bridge/leveldb/query_context.dart';

class TabVaultItemProvider extends TabBaseProvider<VaultItemWrapper> {
  final VaultItemType type;
  late final RepoDB _repoDB;

  TabVaultItemProvider({required this.type}) {
    _repoDB = RepoDB()..init();
  }

  @override
  VaultItemType get dataType => type;

  @override
  void fetchData({bool reset = false}) {
    loading = true;
    Future.delayed(const Duration(seconds: 1), () {
      var queryContext = QueryContext("", EntityType.vaultItem, type, SortBy.values[sortType.index]);
      // query from db
      var entities = _repoDB.query(queryContext);
      // grouping
      var entityGroups = Groups.grouping(entities, queryContext.sortBy);
      // adapt the entity groups
      var wrappers = <VaultItemWrapper>[];
      for (var group in entityGroups) {
        wrappers.addAll(group.entities.map((e) => VaultItemWrapper(raw: e, groupName: group.name)));
      }
      // update data source
      dataSource = wrappers;
      loading = false;
    });
  }

  @override
  void filterData({required String keyword}) {
    // TODO: implement filterData
  }

  @override
  void loadMoreData({int count = 100}) {
    // TODO: implement loadMoreData
  }

  @override
  void dispose() {
    super.dispose();
    _repoDB.close();
  }

}