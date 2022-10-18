import 'package:flutter/cupertino.dart';
import 'package:zpass/base/base_provider.dart';
import 'package:zpass/modules/home/provider/vault_item_sort_type.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';

abstract class TabBaseProvider<T> extends BaseProvider {
  @protected
  VaultItemType get dataType;

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool loading) {
    _loading = loading;
    notifyListeners();
  }

  VaultItemSortType _sortType = VaultItemSortType.lastUsed;
  VaultItemSortType get sortType => _sortType;
  set sortType(VaultItemSortType type) {
    _sortType = type;
    notifyListeners();
  }

  List<T> _dataSource = [];
  List<T> get dataSource => _dataSource;
  set dataSource(List<T> data) {
    _dataSource = data;
    notifyListeners();
  }

  @protected
  void appendData(List<T> data) {
    _dataSource.addAll(data);
    notifyListeners();
  }

  void fetchData({bool reset = false});

  void loadMoreData({int count = 100});

  void filterData({required String keyword});
}