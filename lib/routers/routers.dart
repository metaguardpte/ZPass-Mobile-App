import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:zpass/modules/home/login_or_new.dart';
import 'package:zpass/modules/setting/router_settting.dart';
import 'package:zpass/modules/user/register/router_register.dart';
import 'package:zpass/modules/home/home_page_v2.dart';
import 'package:zpass/modules/scanner/router_scanner.dart';
import 'package:zpass/modules/user/router_user.dart';
import 'package:zpass/modules/vault/vault_routers.dart';
import 'package:zpass/routers/i_router.dart';
import 'package:zpass/routers/not_found_page.dart';

class Routers {
  static String loginOrNew = '/loginOrNew';
  static String home = '/home';
  static String webViewPage = '/webView';

  static final List<IRouterProvider> _listRouter = [];

  static final FluroRouter router = FluroRouter();

  static void initRoutes() {
    /// specify unregistered route
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        debugPrint('Page Not Found');
        return const NotFoundPage();
      });
    router.define(loginOrNew, handler:Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) => const LoginOrNewPage())
    );
    router.define(home, handler: Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) => const HomePageV2()));

    _listRouter.clear();
    /// register every route module
    _listRouter.add(RoutersVault());
    _listRouter.add(RouterScanner());
    _listRouter.add(RouterUser());
    _listRouter.add(RouterRegister());
    _listRouter.add(RouterSetting());

    /// initialize router
    void initRouter(IRouterProvider routerProvider) {
      routerProvider.initRouter(router);
    }
    _listRouter.forEach(initRouter);
  }
}
