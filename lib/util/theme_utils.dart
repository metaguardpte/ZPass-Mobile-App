import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zpass/res/colors.dart';
import 'package:zpass/util/device_utils.dart';

class ThemeUtils {

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color? getDarkColor(BuildContext context, Color darkColor) {
    return isDark(context) ? darkColor : null;
  }

  static Color? getIconColor(BuildContext context) {
    return isDark(context) ? Colours.dark_text : null;
  }
  
  static Color getStickyHeaderColor(BuildContext context) {
    return isDark(context) ? Colours.dark_bg_gray_ : Colours.bg_gray_;
  }

  static Color getDialogTextFieldColor(BuildContext context) {
    return isDark(context) ? Colours.dark_bg_gray_ : Colours.bg_gray;
  }

  static Color? getKeyboardActionsColor(BuildContext context) {
    return isDark(context) ? Colours.dark_bg_color : Colors.grey[200];
  }

  static StreamSubscription<dynamic>? _subscription;

  /// update navigationBar theme to adapt with system theme
  static void setSystemNavigationBar(ThemeMode mode) {
    /// AnimatedTheme duration is 200ms，update navigation bar theme after 200ms, make it look smooth
    _subscription?.cancel();
    _subscription = Stream.value(1).delay(const Duration(milliseconds: 200)).listen((_) {
      bool isDark = false;
      if (mode == ThemeMode.dark || (mode == ThemeMode.system && window.platformBrightness == Brightness.dark)) {
        isDark = true;
      }
      setSystemBarStyle(isDark: isDark);
    });
  }

  /// set StatusBar/NavigationBar theme (Android only)
  /// Our project set it in android MainActivity
  static void setSystemBarStyle({bool? isDark}) {
    if (Device.isAndroid) {

      final bool isDarkMode = isDark ?? window.platformBrightness == Brightness.dark;
      debugPrint('isDark: $isDarkMode');
      final SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
        /// transparent status
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: isDarkMode ? Colours.dark_bg_color : Colors.white,
        systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      );
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }
  }
}

extension ThemeExtension on BuildContext {
  bool get isDark => ThemeUtils.isDark(this);
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get backgroundColor => Theme.of(this).scaffoldBackgroundColor;
  Color get dialogBackgroundColor => Theme.of(this).canvasColor;
  Color get groupBackground => ThemeUtils.isDark(this) ? Colours.secondBackground_dark : Colours.background;
  Color get secondaryBackground => ThemeUtils.isDark(this) ? Colours.secondBackground_dark : Colours.secondBackground;
  Color get tertiaryBackground => ThemeUtils.isDark(this) ? Colours.tertiaryBackground_dark : Colours.tertiaryBackground;
  Color get textColor1 => ThemeUtils.isDark(this) ? Colours.dark_text1 : Colours.text1;
  Color get textColor2 => ThemeUtils.isDark(this) ? Colours.dark_text2 : Colours.text2;
  Color get textColor3 => ThemeUtils.isDark(this) ? Colours.dark_text3 : Colours.text3;
}
