import 'package:fluro/fluro.dart';
import 'package:fluro/src/fluro_router.dart';
import 'package:zpass/modules/user/register/view/register_page.dart';
import 'package:zpass/routers/i_router.dart';

class RouterRegister extends IRouterProvider {
  static const String register = "/user/register";

  @override
  void initRouter(FluroRouter router) {
    router.define(register, handler: Handler(handlerFunc: (_, __) => const RegisterPage()));
  }
}