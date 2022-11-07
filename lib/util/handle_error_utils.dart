import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:zpass/res/constant.dart';

/// handle error globally
void handleError(void Function() body) {
  /// override FlutterError.onError
  FlutterError.onError = (FlutterErrorDetails details) {
    if (!Constant.inProduction) {
      // dump it to console in debug mode
      FlutterError.dumpErrorToConsole(details);
    } else {
      // handle it with zone in release mode
      Zone.current.handleUncaughtError(details.exception, details.stack!);
    }
  };

  /// runZonedGuarded to handle uncaught error in Flutter
  runZonedGuarded(body, (Object error, StackTrace stackTrace) async {
    await _reportError(error, stackTrace);
  });

}

Future<void> _reportError(Object error, StackTrace stackTrace) async {

  if (!Constant.inProduction) {
    debugPrintStack(
      stackTrace: stackTrace,
      label: error.toString(),
      maxFrames: 100,
    );
  } else {
    /// upload error to wherever you wish
  }

}
