import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/home/model/vault_item_login_detail.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';
import 'package:zpass/res/resources.dart';
import 'package:zpass/extension/string_ext.dart';

class VaultItemWrapper {
  VaultItemEntity raw;

  String groupName;

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

  String? get icon {
    final type = VaultItemType.values[raw.type];
    switch (type) {
      case VaultItemType.login:
        final detail = VaultItemLoginDetail.fromJson(raw.detail);
        final uri = Uri.tryParse(detail.loginUri ?? "");
        if (uri == null) {
          return null;
        }
        final hostWithoutWWW = uri.host.replaceAll("www.", "");
        if (favicons.keys.contains(hostWithoutWWW)) {
          return favicons[hostWithoutWWW];
        } else if ((detail.loginUri ?? "").isUrlWithHttp) {
          return "${uri.origin}/favicon.ico";
        } else if ((detail.loginUri ?? "").isUrlWithoutHttp) {
          return "http://${uri.origin}/favicon.ico";
        } else {
          return null;
        }
      default:
        return null;
    }
  }
}