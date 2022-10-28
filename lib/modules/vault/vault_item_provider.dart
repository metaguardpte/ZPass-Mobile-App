import 'package:zpass/base/base_provider.dart';
import 'package:zpass/modules/home/model/vault_item_entity.dart';

abstract class BaseVaultProvider extends BaseProvider {

  Future<dynamic> analyticsData(VaultItemEntity? data) {
    return Future.value(null);
  }

  VaultItemEntity? _entity;
  VaultItemEntity? get entity => _entity;
  set entity(VaultItemEntity? value) {
    _entity = value;
    notifyListeners();
  }

  bool _editing = false;
  bool get editing => _editing;
  set editing(bool value) {
    if (_editing == value) {
      return;
    }
    _editing = value;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    if (_loading == value) {
      return;
    }
    _loading = value;
    notifyListeners();
  }
}