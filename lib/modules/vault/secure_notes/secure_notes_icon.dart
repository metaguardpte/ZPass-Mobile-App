import 'package:flutter/material.dart';
import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/home/tabs/tab_widget_helper.dart';
import 'package:zpass/modules/vault/vault_detail_helper.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/util/theme_utils.dart';

Widget buildSecureNotesIcon(BuildContext context, VaultItemEntity? entity) {
  return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
          color:const Color.fromRGBO(0,122,249,1),
          borderRadius: BorderRadius.circular(9)),
      child: const Icon(ZPassIcons.favNotes,size: 28,color: Colors.white,)
  );
}
