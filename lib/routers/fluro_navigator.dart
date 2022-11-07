import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import 'routers.dart';

class NavigatorUtils {
  
  static void push(BuildContext context, String path,
      {bool replace = false, bool clearStack = false, Object? arguments}) {
    unfocus();
    Routers.router.navigateTo(context, path,
      replace: replace,
      clearStack: clearStack,
      transition: TransitionType.native,
      routeSettings: RouteSettings(
        arguments: arguments,
      ),
    );
  }

  static void pushResult(BuildContext context, String path, Function(Object) function,
      {bool replace = false, bool clearStack = false, Object? arguments}) {
    unfocus();
    Routers.router.navigateTo(context, path,
      replace: replace,
      clearStack: clearStack,
      transition: TransitionType.native,
      routeSettings: RouteSettings(
        arguments: arguments,
      ),
    ).then((Object? result) {
      // 页面返回result为null
      if (result == null) {
        return;
      }
      function(result);
    }).catchError((dynamic error) {
      debugPrint('$error');
    });
  }

  static void goBack(BuildContext context) {
    unfocus();
    Navigator.pop(context);
  }

  static void goBackWithParams(BuildContext context, Object result) {
    unfocus();
    Navigator.pop<Object>(context, result);
  }
  
  static void goWebViewPage(BuildContext context, String title, String url) {
    //chinese is unsupported in Fluro, encode all parameters
    push(context, '${Routers.webViewPage}?title=${Uri.encodeComponent(title)}&url=${Uri.encodeComponent(url)}');
  }

  static void unfocus() {
    // this solution will trigger unnecessary build
    // FocusScope.of(context).unfocus();
    // https://github.com/flutter/flutter/issues/47128#issuecomment-627551073
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
