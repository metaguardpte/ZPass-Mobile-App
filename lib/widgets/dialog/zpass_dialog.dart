import 'package:flutter/material.dart';

/// 使用：
/// 自定义 dialog 可继承 LinkFoxDialog，然后在 build 函数构造一个 Widget 即可，里面就可以随便玩了
/// 无需更新状态 - 可参考：LoadingDialog 的实现
/// 需更新状态 - 可参考：ProgressDialog 的实现
abstract class ZPassDialog {
  var _isShowing = false;

  /// barrierDismissible：点击空白处 or 点击返回键 消失，默认为 true = 消失
  /// pauseBackground：是否pause背景widget（上一个页面）
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
            //返回键事件拦截
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
