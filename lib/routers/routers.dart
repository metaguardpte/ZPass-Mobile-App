import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:zpass/modules/home/loginOrNew.dart';
import 'package:zpass/modules/user/register/router_register.dart';
import 'package:zpass/modules/home/home_page_v2.dart';
import 'package:zpass/modules/scanner/router_scanner.dart';
import 'package:zpass/modules/user/router_user.dart';
import 'package:zpass/routers/i_router.dart';
import 'package:zpass/routers/not_found_page.dart';

class Routers {
  static String loginOrNew = '/loginOrNew';
  static String home = '/home';
  static String webViewPage = '/webView';

  static final List<IRouterProvider> _listRouter = [];

  static final FluroRouter router = FluroRouter();

  static void initRoutes() {
    /// 指定路由跳转错误返回页
    router.notFoundHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
        debugPrint('未找到目标页');
        return const NotFoundPage();
      });
    router.define(loginOrNew, handler:Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) => const LoginOrNewPage())
    );
    router.define(home, handler: Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) => const HomePageV2()));
    
    _listRouter.clear();
    /// 各自路由由各自模块管理，统一在此添加初始化
    _listRouter.add(RouterScanner());
    _listRouter.add(RouterUser());
    _listRouter.add(RouterRegister());
    /// 初始化路由
    void initRouter(IRouterProvider routerProvider) {
      routerProvider.initRouter(router);
    }
    _listRouter.forEach(initRouter);
  }
}
