import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zpass/modules/home/widgets/app_bar_builder.dart';
import 'package:zpass/res/zpass_fonts_icons.dart';
import 'package:zpass/util/log_utils.dart';
import 'package:zpass/util/theme_utils.dart';
import 'package:zpass/widgets/load_image.dart';

class HomeAppBarBuilder extends AppBarBuilder {
  @override
  PreferredSizeWidget build(BuildContext context) {
    final Color? iconColor = ThemeUtils.getIconColor(context);
    return AppBar(
      automaticallyImplyLeading: applyLeading(),
      leading: Container(margin: const EdgeInsets.only(left: 16),child: const LoadAssetImage("logo_zpass"),),
      leadingWidth: 110,
      backgroundColor: context.primaryColor,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: <Color>[Color(0xFF5273FE), Color(0xFF4342FF)]),
        ),
      ),
      actions: [
        IconButton(
          tooltip: 'scan',
          onPressed: () => _navigate(context, "scan"),
          icon: Icon(ZPassFonts.scan, color: iconColor,),
        ),
        IconButton(
          tooltip: 'message',
          onPressed: () => _navigate(context, "message"),
          icon: Icon(ZPassFonts.information, color: iconColor,),
        ),
        IconButton(
          tooltip: 'setting',
          onPressed: () => _navigate(context, "setting"),
          icon: Icon(ZPassFonts.more, color: iconColor,),
        ),
      ]
    );
  }

  @override
  bool applyLeading() {
    return false;
  }

  void _navigate(BuildContext context, String type) {
    Log.d("navigate to $type", tag: "HomeAppBarBuilder");
  }
}