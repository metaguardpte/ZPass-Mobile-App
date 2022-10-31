import 'package:flutter/material.dart';
import 'package:zpass/extension/string_ext.dart';
import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/home/model/vault_item_login_detail.dart';
import 'package:zpass/modules/home/tabs/tab_widget_helper.dart';
import 'package:zpass/res/resources.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/util/theme_utils.dart';

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

Widget buildHint(BuildContext context, String hint, {bool require = false}) {
  return Row(
    children: [
      Visibility(
          visible: require,
          child: Text(
            "*",
            style: TextStyles.textSize14.copyWith(color: Colours.app_error),
          )),
      Text(hint,
          style: TextStyles.textSize14.copyWith(color: context.textColor1))
    ],
  );
}

Widget buildRowIcon(BuildContext context, IconData? icon, {Color? color, Color? backgroundColor}) {
  return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
          color: backgroundColor ?? context.tertiaryBackground,
          borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon ?? ZPassIcons.icPhoto, color: color, size: 32,),
  );

}