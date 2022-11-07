import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:zpass/res/colors.dart';
import 'package:zpass/res/gaps.dart';
import 'package:zpass/res/zpass_icons.dart';

enum ToastType { warning, error, info ,success}

class Toast {
  static ToastFuture? show(String? msg) {
    if (msg == null) {
      return null;
    }
    return showSpec(msg);
  }

  static ToastFuture? showError(String? msg) {
    if (msg == null) {
      return null;
    }
    return showSpec(msg, type: ToastType.error);
  }
  static ToastFuture? showSuccess(String? msg){
    if (msg == null) {
      return null;
    }
    return showSpec(msg, type: ToastType.success);
  }

  static ToastFuture? showWaring(String? msg) {
    if (msg == null) {
      return null;
    }
    return showSpec(msg, type: ToastType.warning);
  }

  static ToastFuture? showSpec(String? msg, {ToastType type = ToastType.info}) {
    if (msg == null) {
      return null;
    }
    final Widget widget = Container(
      constraints: const BoxConstraints(maxWidth: 270, minHeight: 60),
      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colours.black80,
      ),
      child: ClipRect(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_switchIcon(type), color: Colors.white, size: 36,),
            Gaps.vGap8,
            Text(
              msg,
              maxLines: 8,
              overflow: TextOverflow.fade,
              style: const TextStyle(height: 1.3),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
    return showToastWidget(
      widget,
    );
  }

  static IconData _switchIcon(ToastType type) {
    switch (type) {
      case ToastType.warning:
        return ZPassIcons.icWarningTriangle;
      case ToastType.error:
        return ZPassIcons.icXCircle;
      case ToastType.success:
        return ZPassIcons.icSuccess;
      case ToastType.info:

      default:
        return ZPassIcons.icInfo;
    }
  }

  static void cancelToast() {
    dismissAllToast();
  }
}
