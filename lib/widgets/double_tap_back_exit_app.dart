import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/util/callback_funcation.dart';
import 'package:zpass/util/toast_utils.dart';

/// Double tab back to exit
class DoubleTapBackExitApp extends StatefulWidget {
  final NullParamFunctionReturn<bool>? backConsumer;

  const DoubleTapBackExitApp({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 2500),
    this.backConsumer,
  });

  final Widget child;
  /// duration between taps
  final Duration duration;

  @override
  _DoubleTapBackExitAppState createState() => _DoubleTapBackExitAppState();
}

class _DoubleTapBackExitAppState extends State<DoubleTapBackExitApp> {

  DateTime? _lastTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _consume,
      child: widget.child,
    );
  }

  Future<bool> _consume() {
    if (widget.backConsumer?.call() ?? false) {
      // back event handled by outside, return false to interrupt it
      return Future.value(false);
    }
    return _isExit();
  }

  Future<bool> _isExit() async {
    if (_lastTime == null || DateTime.now().difference(_lastTime!) > widget.duration) {
      _lastTime = DateTime.now();
      Toast.show(S.current.appExitTips);
      return Future.value(false);
    }
    Toast.cancelToast();
    /// exit(0) from dart:io is NOT recommended
    if (Platform.isAndroid) {
      // SystemNavigatorProxy.exit();
      await SystemNavigator.pop();
    } else {
      await SystemNavigator.pop();
    }
    return Future.value(true);
  }
}
