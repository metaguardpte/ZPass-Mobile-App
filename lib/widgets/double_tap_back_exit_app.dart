import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/rpc/proxies/system_navigator_proxy.dart';
import 'package:zpass/util/toast_utils.dart';

/// 双击返回退出
class DoubleTapBackExitApp extends StatefulWidget {

  const DoubleTapBackExitApp({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 2500),
  });

  final Widget child;
  /// 两次点击返回按钮的时间间隔
  final Duration duration;

  @override
  _DoubleTapBackExitAppState createState() => _DoubleTapBackExitAppState();
}

class _DoubleTapBackExitAppState extends State<DoubleTapBackExitApp> {

  DateTime? _lastTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _isExit,
      child: widget.child,
    );
  }

  Future<bool> _isExit() async {
    if (_lastTime == null || DateTime.now().difference(_lastTime!) > widget.duration) {
      _lastTime = DateTime.now();
      Toast.show(S.current.appExitTips);
      return Future.value(false);
    }
    Toast.cancelToast();
    /// 不推荐使用 `dart:io` 的 exit(0)
    if (Platform.isAndroid) {
      // SystemNavigatorProxy.exit();
      await SystemNavigator.pop();
    } else {
      await SystemNavigator.pop();
    }
    return Future.value(true);
  }
}
