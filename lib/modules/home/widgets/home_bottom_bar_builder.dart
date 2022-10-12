import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:zpass/res/colors.dart';

class HomeBottomBarBuilder extends DelegateBuilder {
  late final List<TabItem> items;
  late final Color _tabBackgroundColor;

  HomeBottomBarBuilder(this.items, this._tabBackgroundColor);

  @override
  Widget build(BuildContext context, int index, bool active) {
    var navigationItem = items[index];
    var color = active ? Colours.app_main : Colours.unselected_item_color;

    if (index == items.length ~/ 2) {
      return Container(
        margin: const EdgeInsets.fromLTRB(5, 10, 5, 15),
        decoration: const BoxDecoration(shape: BoxShape.circle, color: Colours.app_main),
        child: const Icon(
          Icons.add,
          size: 40,
          color: Colors.white,
        ),
      );
    }
    var icon = active
        ? navigationItem.activeIcon ?? navigationItem.icon
        : navigationItem.icon;
    var title = navigationItem.title ?? "";
    return Container(
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.only(bottom: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(icon, color: color,),
          Text(title, style: TextStyle(color: color, fontSize: 11))
        ],
      ),
    );
  }

  @override
  bool fixed() {
    return true;
  }
}