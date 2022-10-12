import 'dart:ui';

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:zpass/res/colors.dart';
// ignore: implementation_imports
import 'package:flutter/src/painting/text_style.dart';

class HomeBottomBarStyle extends StyleHook {
  @override
  double get activeIconSize => 40;

  @override
  double get activeIconMargin => 10;

  @override
  double get iconSize => 20;

  @override
  TextStyle textStyle(Color color, String? fontFamily) {
    return const TextStyle(fontSize: 11, color: Colours.app_main, fontFamily: null);
  }
}