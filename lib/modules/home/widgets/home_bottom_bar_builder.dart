import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:zpass/modules/home/home_page_v2.dart';
import 'package:zpass/res/colors.dart';

class HomeBottomBarBuilder extends DelegateBuilder {
  late final List<TabItem> items;
  late final Color _tabBackgroundColor;

  HomeBottomBarBuilder(this.items, this._tabBackgroundColor);

  @override
  Widget build(BuildContext context, int index, bool active) {
    var navigationItem = items[index];
    var color = active ? Colours.app_main : Colours.unselected_item_color;

    if (index == HomePageV2.dockedFake) {
      return Container(
        margin: const EdgeInsets.fromLTRB(5, 8, 5, 20),
        decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(
          colors: [Color(0xFF5273FE), Color(0xFF4342FF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        )),
        child: Icon(
          items[index].icon,
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
      margin: const EdgeInsets.symmetric(vertical: 7),
      padding: const EdgeInsets.only(bottom: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(icon, color: color,),
          const SizedBox(height: 2,),
          Text(title, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w400))
        ],
      ),
    );
  }

  @override
  bool fixed() {
    return true;
  }
}