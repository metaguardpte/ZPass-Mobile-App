import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:zpass/modules/home/model/vault_item_wrapper.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';
import 'package:zpass/res/resources.dart';
import 'package:zpass/util/theme_utils.dart';
import 'package:zpass/widgets/load_image.dart';

Widget renderListGroupItem(BuildContext context, VaultItemWrapper element, bool groupStart, bool groupEnd) {
  BorderRadiusGeometry? radius;
  if (groupStart && groupEnd) {
    radius = BorderRadius.circular(11);
  } else if (groupStart) {
    radius = const BorderRadius.only(topLeft: Radius.circular(11), topRight: Radius.circular(11));
  } else if (groupEnd) {
    radius = const BorderRadius.only(bottomLeft: Radius.circular(11), bottomRight: Radius.circular(11));
  }
  return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration:
      BoxDecoration(color: context.tertiaryBackground, borderRadius: radius),
      child: _renderListContent(context, element));
}

Widget renderListItem(BuildContext context, VaultItemWrapper element) {
  return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: context.tertiaryBackground,
      ),
      child: _renderListContent(context, element));
}

Widget renderVaultFavIcon({required int vaultType, String? iconUrl}) {
  final randomColors = faviconColors[
          math.Random().nextInt(100) % faviconColorsGradient.length] ??
      Colours.app_main;
  final fallbackIcon = Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
          // gradient: LinearGradient(colors: randomColors),
          color: randomColors,
          borderRadius: BorderRadius.circular(9)),
      child: Icon(
        VaultItemType.values[vaultType].defaultFav,
        color: Colors.white,
      ));
  return iconUrl != null
      ? ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: LoadImage(
            iconUrl,
            holderError: fallbackIcon,
          ))
      : fallbackIcon;
}

Widget _renderListContent(BuildContext context, VaultItemWrapper element) {
  final noSubTitle = element.raw.type == VaultItemType.note.index;
  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: noSubTitle ? 2 : 0),
    horizontalTitleGap: 6,
    minVerticalPadding: 0,
    leading: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
                color: context.tertiaryBackground,
                // border: Border.all(
                //   width: 0.5,
                //   color: context.textColor2,
                // ),
                borderRadius: BorderRadius.circular(9)),
            child: renderVaultFavIcon(vaultType: element.raw.type, iconUrl: element.icon)),
      ],
    ),
    title: Text(element.title, style: TextStyle(color: context.textColor1, fontSize: 15, fontWeight: FontWeight.w500),),
    subtitle: noSubTitle ? null :Text(element.subtitle, style: TextStyles.textSize12.copyWith(color: const Color(0xFF959BA7),)),
    trailing: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.arrow_forward_ios, color: Color(0xFFC8CDD7), size: 15,)
      ],
    ),
  );
}