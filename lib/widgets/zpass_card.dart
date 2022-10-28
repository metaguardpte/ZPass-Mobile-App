import 'package:flutter/material.dart';
import 'package:zpass/res/colors.dart';
import 'package:zpass/util/theme_utils.dart';

class ZPassCard extends StatelessWidget {
  const ZPassCard(
      {super.key,
      required this.child,
      this.color,
      this.shadowColor,
      this.borderColor,
      this.padding,
      this.margin,
      this.borderRadius = 8.0});

  final double borderRadius;
  final Widget child;
  final Color? color;
  final Color? shadowColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.isDark;

    final Color backgroundColor = color ?? context.groupBackground;
    final Color shadowColor =
        isDark ? Colors.transparent : (this.shadowColor ?? const Color(0x80DCE7FA));
    Border? borders;
    if (borderColor != null) {
      borders = Border.all(color: borderColor ?? Colours.app_main, width: 2);
    }

    return Container(
      width: double.infinity,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
          color: backgroundColor,
          border: borders,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: shadowColor,
                offset: const Offset(0.0, 2.0),
                blurRadius: 8.0,
                spreadRadius: 0.0),
          ]),
      child: child,
    );
  }
}
