import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:zpass/modules/vault/login/login_detail_page.dart';
import 'package:zpass/routers/i_router.dart';

class RoutersVault extends IRouterProvider {
  static const String vaultDetailLogin = "/home/vault/login";

  @override
  void initRouter(FluroRouter router) {
    router.define(vaultDetailLogin, handler: Handler(handlerFunc: (context, _) {
      final args = ModalRoute.of(context!)?.settings.arguments as Map<String, dynamic>?;
      final item = args != null ? args["item"] : null;
      return LoginDetailPage(data: item,);
    }));
  }
}