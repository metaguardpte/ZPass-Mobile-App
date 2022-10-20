import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/widgets/dialog/zpass_dialog.dart';
import 'package:zpass/util/theme_utils.dart';

/// 使用：
class ZPassMiddleDialog extends ZPassDialog {
  late final String _text;
  late final Widget? _child;
  late final Widget? _footer;

  ZPassMiddleDialog({String text = "", Widget? child,Widget? footer}) {
    _text = text.isEmpty ? S.current.tipsLoading : text;
    _child = child;
    _footer = footer;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.all(30),
        decoration: BoxDecoration(
            color: context.dialogBackgroundColor,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding:const EdgeInsets.fromLTRB(20, 30, 20, 30),
              alignment: Alignment.center,
              decoration: UnderlineTabIndicator(
                borderSide:_footer != null ?const BorderSide(
                    width: 0.5, color: Color.fromRGBO(235, 235, 238, 1)) : BorderSide.none,
              ),
              child: _child,
            ),
            Container(
              alignment: Alignment.center,
              padding: _footer != null ? const EdgeInsets.fromLTRB(20, 30, 20, 30) : const EdgeInsets.all(0),
              child: _footer,
            )
          ],
        ),
      ),
    );
  }
}
