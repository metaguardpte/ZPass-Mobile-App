import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:zpass/widgets/load_image.dart';

enum ToastType { warning, error, info }

/// Toast工具类
class Toast {
  static void show(String? msg, {int duration = 2000}) {
    if (msg == null) {
      return;
    }
    showToast(msg,
        duration: Duration(milliseconds: duration),
        dismissOtherToast: true,
        position: ToastPosition.center,
        radius: 5,
        textStyle: const TextStyle(fontSize: 18, color: Colors.white));
  }

  static String SwitchIcon(ToastType type) {
    var imageUrl = '';
    switch (type) {
      case ToastType.info:
        imageUrl = '2.0x/Info@2x';
        break;
      case ToastType.warning:
        imageUrl = '2.0x/Warning@2x';
        break;
      case ToastType.error:
        imageUrl = '2.0x/XCircle@2x';
        break;
    }
    return imageUrl;
  }

  static void showMiddleToast(String? msg,
      {int duration = 2000, ToastType type = ToastType.info}) {
    showToastWidget(
      Container(
        constraints:const BoxConstraints(maxWidth: 270, minWidth: 200),
        padding: const EdgeInsets.fromLTRB(21, 24, 21, 0),

        height: 120,
        decoration: const BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.8000),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Column(
          children: [
            LoadAssetImage(
              SwitchIcon(type),
              width: 36,
              height: 36,
            ),
            Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  msg ?? '',
                  style: const TextStyle(fontSize: 18),
                ))
          ],
        ),
      ),
      dismissOtherToast: true,
      position: ToastPosition.center,
    );
  }

  static void cancelToast() {
    dismissAllToast();
  }
}
