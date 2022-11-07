import 'package:flutter/material.dart';
import 'package:zpass/widgets/dialog/zpass_loading_dialog.dart';

/// Usage:
/// Extends ZPassDialog，build widget in build function.
/// For stateless, check [ZPassLoadingDialog];
abstract class ZPassDialog {
  var _isShowing = false;

  /// barrierDismissible: click outside or press back to dismiss
  Future<bool> show(BuildContext context,
      {bool barrierDismissible = true,
      Color barrierColor = const Color(0x80000000),
      bool useSafeArea = true,
      Function? onDismiss,
      bool pauseBackground = false}) async {
    if (_isShowing) {
      return Future.value(true);
    }
    _isShowing = true;

    onStart();

    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      useSafeArea: useSafeArea,
      useRootNavigator: false,
      routeSettings: const RouteSettings(name: "zpass_dialog"),
      builder: (context) {
        return WillPopScope(
            onWillPop: () async => barrierDismissible,
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(children: [
                GestureDetector(
                  onTap: () {
                    if (barrierDismissible == true) {
                      dismiss(context);
                    }
                  },
                ),
                build(context)
              ]),
            ));
      },
    ).whenComplete(() {
      _isShowing = false;
      onDismiss?.call();
      onStop();
    }).then((value) => Future.value(true));
  }

  Widget build(BuildContext context);

  bool isShowing() {
    return _isShowing;
  }

  dismiss(BuildContext context) {
    if (_isShowing) {
      _isShowing = false;
      Navigator.pop(context);
    }
  }

  void onStart() {}

  void onStop() {}
}
