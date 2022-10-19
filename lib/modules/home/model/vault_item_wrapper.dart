import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/home/model/vault_item_login_detail.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';

class VaultItemWrapper {
  VaultItemEntity raw;

  String groupName;
  String? iconLocal;
  String? iconRemote;

  VaultItemWrapper({required this.raw, required this.groupName});

  String get title => raw.name;
  String get subtitle {
    final type = VaultItemType.values[raw.type];
    switch (type) {
      case VaultItemType.login:
        final detail = VaultItemLoginDetail.fromJson(raw.detail);
        return detail.loginUri ?? "";
      default:
        return raw.description ?? "";
    }
  }
}