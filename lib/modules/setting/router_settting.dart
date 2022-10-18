import 'package:fluro/fluro.dart';
import 'package:zpass/modules/setting/setting_page.dart';
import 'package:zpass/routers/i_router.dart';

class RouterUser extends IRouterProvider {
  static const String setting = '/setting';

  @override
  void initRouter(FluroRouter router) {
    router.define(setting,
        handler: Handler(handlerFunc: (_, __) => const SettingPage()));
  }
}