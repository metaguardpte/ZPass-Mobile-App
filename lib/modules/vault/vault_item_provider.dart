import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
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

  bool _hasChange = false;
  bool get hasChange => _hasChange;
  set hasChange(bool value) {
    _hasChange = value;
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

  Future<dynamic> updateData(
      {required String title,
      required String name,
      required String passwd,
      required String url,
      String? note,}) {
    if (entity == null) {
      return Future.error("vault entity is null");
    }

    entity!.name = title;
    return db.update(entity!);
  }

  String generateItemId() => const Uuid().v4().replaceAll("-", "");
}