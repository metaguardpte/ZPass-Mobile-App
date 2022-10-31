import 'package:flutter/cupertino.dart';
import 'package:zpass/base/base_provider.dart';
import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/home/repo/repo_db.dart';

abstract class BaseVaultProvider extends BaseProvider {

  @protected
  late final RepoDB db;

  BaseVaultProvider(this.db);

  VaultItemEntity? _entity;
  VaultItemEntity? get entity => _entity;
  set entity(VaultItemEntity? value) {
    _entity = value;
    notifyListeners();
  }

  bool _editing = true;
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

  Future<dynamic> analyticsData(VaultItemEntity? data) {
    return Future.value(null);
  }

  Future<dynamic> removeData() {
    if (entity == null) {
      return Future.error("vault entity is null");
    }
    return db.remove(entity!);
  }
}