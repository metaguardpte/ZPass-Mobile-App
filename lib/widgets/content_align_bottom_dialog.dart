import 'package:flutter/material.dart';
import 'package:zpass/util/theme_utils.dart';

///
/// Align Bottom Dialog
///
/// example
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
/// usage
///
/// DemoBottomDialog().show(context, isDismissible: false);
///
abstract class ContentAlignBottomDialog {
  final String? name;
  var _showing = false;

  bool get isShowing => _showing;

  ContentAlignBottomDialog({this.name});

  Future<bool> show(BuildContext context,
      {bool isDismissible = true,
      Function? onDismiss,
      Color? backgroundColor}) async {
    if (_showing) {
      return Future.value(false);
    }
    onStartShow();
    return showModalBottomSheet(
        context: context,
        isDismissible: isDismissible,
        backgroundColor: backgroundColor ?? context.dialogBackgroundColor,
        barrierColor: const Color(0xCC000000),
        isScrollControlled: true,
        routeSettings: RouteSettings(name: "BottomDialog-${name ?? "unknown"}"),
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: buildContent(context),
          );
        }).whenComplete(() {
      _showing = false;
      onDismiss?.call();
    }).then((value) => Future.value(true));
  }

  @protected
  Widget buildContent(BuildContext context);

  @protected
  dismiss(BuildContext context) {
    if (!_showing) {
      return;
    }
    _showing = false;
    Navigator.pop(context);
  }

  @mustCallSuper
  @protected
  void onStartShow() {
    _showing = true;
  }
}
