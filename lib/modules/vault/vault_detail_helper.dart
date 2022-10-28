import 'package:zpass/extension/string_ext.dart';
import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/home/model/vault_item_login_detail.dart';
import 'package:zpass/res/resources.dart';

String? parseVaultLoginIconUrl(VaultItemEntity? entity) {
  if (entity == null) {
    return null;
  } else {
    final detail = VaultItemLoginDetail.fromJson(entity.detail);
    final uri = Uri.tryParse(detail.loginUri ?? "");
    if (uri == null) {
      return null;
    }
    final hostWithoutWWW = uri.host.replaceAll("www.", "");
    if (favicons.keys.contains(hostWithoutWWW)) {
      return favicons[hostWithoutWWW];
    } else if ((detail.loginUri ?? "").isUrl) {
      if (detail.loginUri!.startsWith("http")) {
        return "${uri.origin}/favicon.ico";
      } else {
        return "http://${uri.origin}/favicon.ico";
      }
    } else {
      return null;
    }
  }
}