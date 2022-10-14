import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/home/provider/tab_base_provider.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';
import 'package:zpass/modules/home/repo/repo_mock.dart';

class TabVaultItemProvider extends TabBaseProvider<VaultItemEntity> {
  final VaultItemType type;
  late final RepoMock _repo;

  TabVaultItemProvider({required this.type}) {
    _repo = RepoMock()..init();
  }

  @override
  VaultItemType get dataType => type;

  @override
  void fetchData({bool reset = false}) {
    loading = true;
    Future.delayed(const Duration(seconds: 1), () {
      dataSource = _repo.filterByType(type);
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

}