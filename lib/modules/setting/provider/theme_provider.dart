import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sp_util/sp_util.dart';
import 'package:zpass/res/colors.dart';
import 'package:zpass/res/constant.dart';
import 'package:zpass/res/styles.dart';
import 'package:zpass/routers/web_page_transitions.dart';

extension ThemeModeExtension on ThemeMode {
  String get value => <String>['System', 'Light', 'Dark'][index];
}

class ThemeProvider extends ChangeNotifier {
  
  void syncTheme() {
    final String theme = SpUtil.getString(Constant.theme) ?? '';
    if (theme.isNotEmpty && theme != ThemeMode.system.value) {
      notifyListeners();
    }
  }

  void setTheme(ThemeMode themeMode) {
    SpUtil.putString(Constant.theme, themeMode.value);
    notifyListeners();
  }

  ThemeMode getThemeMode(){
    final String theme = SpUtil.getString(Constant.theme) ?? '';
    switch(theme) {
      case 'Dark':
        return ThemeMode.dark;
      case 'Light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  }

  ThemeData getTheme({bool isDarkMode = false}) {
    return ThemeData(
      errorColor: isDarkMode ? Colours.dark_red : Colours.red,
      primaryColor: isDarkMode ? Colours.dark_app_main : Colours.app_main,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        secondary: isDarkMode ? Colours.dark_app_main : Colours.app_main,
      ),
      // Tab indicator color
      indicatorColor: isDarkMode ? Colours.dark_app_main : Colours.app_main,
      // scaffold background
      scaffoldBackgroundColor: isDarkMode ? Colours.secondBackground_dark : Colours.secondBackground,
      // material background
      canvasColor: isDarkMode ? Colours.dark_material_bg : Colors.white,
      // textSelectionColor: Colours.app_main.withAlpha(70),
      // textSelectionHandleColor: Colours.app_main,
      // stable 1.23 change: (https://flutter.dev/docs/release/breaking-changes/text-selection-theme)
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: Colours.app_main.withAlpha(70),
        selectionHandleColor: Colours.app_main,
        cursorColor: Colours.app_main,
      ),
      textTheme: TextTheme(
        subtitle1: isDarkMode ? TextStyles.textDark : TextStyles.text,
        bodyText2: isDarkMode ? TextStyles.textDark : TextStyles.text,
        subtitle2: isDarkMode ? TextStyles.textDarkGray12 : TextStyles.textGray12,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: isDarkMode ? TextStyles.textHint14 : TextStyles.textDarkGray14,
        fillColor: isDarkMode ? Colours.dark_bg_gray : const Color(0xFFF9F9F9),
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(7.5),
        //   borderSide: BorderSide(
        //       width: 0.5,
        //       color: isDarkMode ? Colours.dark_material_bg : const Color(0xFFEBEBEE)),
        // ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.5),
          borderSide: BorderSide(
              color: isDarkMode ? Colours.dark_app_main : Colours.app_main),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.5),
          borderSide: BorderSide(
              width: 0.5,
              color: isDarkMode ? Colours.dark_material_bg : const Color(0xFFEBEBEE)),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.5),
          borderSide: BorderSide(
              width: 0.5,
              color: isDarkMode ? Colours.dark_material_bg : const Color(0xFFEBEBEE)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(7.5),
          borderSide: BorderSide(
              color: isDarkMode ? Colours.dark_app_error : Colours.app_error),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        centerTitle: true,
        color: isDarkMode ? Colours.background_dark : Colours.background,
        iconTheme: IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        actionsIconTheme: IconThemeData(color: isDarkMode ? Colours.dark_app_main : Colours.app_main),
        systemOverlayStyle: isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        titleTextStyle: isDarkMode ? TextStyles.textAppbarDark : TextStyles.textAppbar,
      ),
      dividerTheme: DividerThemeData(
        color: isDarkMode ? Colours.dark_line : Colours.line,
        space: 0.6,
        thickness: 0.6
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
      pageTransitionsTheme: NoTransitionsOnWeb(),
      visualDensity: VisualDensity.standard,  // https://github.com/flutter/flutter/issues/77142
    );
  }

}
