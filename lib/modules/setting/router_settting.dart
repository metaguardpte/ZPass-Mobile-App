import 'package:fluro/fluro.dart';
import 'package:zpass/modules/setting/data_roaming/data_roaming.dart';
import 'package:zpass/modules/setting/setting_page.dart';
import 'package:zpass/modules/setting/user_info_setting.dart';
import 'package:zpass/routers/i_router.dart';

class RouterSetting extends IRouterProvider {
  static const String setting = '/setting';
  static const String userInfoSetting = '/setting/userinfo';
  static const String dataRoaming = '/setting/dataRoaming';

  @override
  void initRouter(FluroRouter router) {
    router.define(setting,
        handler: Handler(handlerFunc: (_, __) => const SettingPage()));
    router.define(userInfoSetting,
        handler: Handler(handlerFunc: (_, __) => const UserInfoSettingPage()));
    router.define(dataRoaming,
        handler: Handler(handlerFunc: (_, __) => const DataRoamingPage()));
  }
}