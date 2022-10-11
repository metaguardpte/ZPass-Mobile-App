import 'package:flutter/material.dart';

///
/// 内容靠底的弹窗
/// example
///
/// 弹窗自定义
///
/// class DemoBottomDialog extends ContentAlignBottomDialog {
///   @override
///   Widget buildContent(BuildContext context) {
///     return Container(child: Text("Hello"));
///   }
///
///   @override
///   void onDismiss(BuildContext context) {
///     super.onDismiss(context);
///   }
/// }
///
/// 调用方式
///
/// DemoBottomDialog().show(context, isDismissible: false);
///
abstract class ContentAlignBottomDialog {
  final String? name;
  var _isShowing = false;

  ContentAlignBottomDialog({this.name});

  Future<bool> show(BuildContext context,
      {bool isDismissible = true, Function? onDismissCallback}) async {
    if (_isShowing) {
      return Future.value(false);
    }
    _isShowing = true;
    onStartShow();

    return showModalBottomSheet(
        context: context,
        isDismissible: isDismissible,
        backgroundColor: Colors.transparent,
        barrierColor: const Color(0xCC000000),
        isScrollControlled: true,
        routeSettings: RouteSettings(name: "BottomDialog-${name ?? "unknown"}"),
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: buildContent(context),
          );
        }).whenComplete(() {
      _isShowing = false;
      onDismissCallback?.call();
      onDismiss.call(context);
    }).then((value) => Future.value(true));
  }

  Widget buildContent(BuildContext context);

  bool isShowing() {
    return _isShowing;
  }

  dismiss(BuildContext context) {
    if (_isShowing) {
      Navigator.pop(context);
    }
  }

  void onDismiss(BuildContext context) {
    _isShowing = false;
  }

  void onStartShow() {}
}
