import 'package:flutter/material.dart';
import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/home/tabs/tab_widget_helper.dart';
import 'package:zpass/modules/vault/vault_detail_helper.dart';
import 'package:zpass/res/colors.dart';
import 'package:zpass/res/styles.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/util/theme_utils.dart';

Widget buildHint(BuildContext context, String hint, {bool star = false}) {
  return Row(
    children: [
      Visibility(
          visible: star,
          child: Text(
            "*",
            style: TextStyles.textSize14.copyWith(color: Colours.app_error),
          )),
      Text(hint,
          style: TextStyles.textSize14.copyWith(color: context.textColor1))
    ],
  );
}

Widget buildLoginFav(BuildContext context, VaultItemEntity? entity) {
  return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
          color: context.tertiaryBackground,
          borderRadius: BorderRadius.circular(9)),
      child: entity == null
          ? const Icon(ZPassIcons.icPhoto)
          : renderVaultFavIcon(
              vaultType: entity.type, iconUrl: parseVaultLoginIconUrl(entity)));
}
