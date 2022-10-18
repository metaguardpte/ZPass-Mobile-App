import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:zpass/modules/user/signin/signin_page.dart';
import 'package:zpass/routers/i_router.dart';

class RouterUser extends IRouterProvider {
  static const String login = '/user/login';

  @override
  void initRouter(FluroRouter router) {
    router.define(login,
        handler: Handler(handlerFunc: (context, params) {
          final args = ModalRoute.of(context!)?.settings.arguments as Map<String, dynamic>?;
          return SignInPage(data: args?["data"]);
        }));
  }
}