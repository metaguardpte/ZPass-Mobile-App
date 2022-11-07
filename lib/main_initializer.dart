import 'package:dio/dio.dart';
import 'package:sp_util/sp_util.dart';
import 'package:zpass/base/app_config.dart';
import 'package:zpass/base/network/httpclient.dart';
import 'package:zpass/base/network/intercept.dart';
import 'package:zpass/modules/sync/sync_task.dart';
import 'package:zpass/modules/user/user_provider.dart';
import 'package:zpass/res/constant.dart';
import 'package:zpass/routers/routers.dart';
import 'package:zpass/rpc/rpc_manager.dart';
import 'package:zpass/util/log_utils.dart';

class MainInitializer {
  ///
  /// Initialize before user authorize
  ///
  /// IMPORTANT: do NOT initialize any module which require permission
  ///
  static Future<void> initBeforeAuthorize() async {
    // rpc
    RpcManager.instance.startListening();
    // sp
    await SpUtil.getInstance();
    // route
    Routers.initRoutes();
    // log
    Log.init();
    // dio
    _initDio();
  }

  static void _initDio() {
    final List<Interceptor> interceptors = <Interceptor>[];

    /// add token interceptor
    interceptors.add(AuthInterceptor());

    /// add token refresh interceptor
    interceptors.add(TokenInterceptor());

    /// add log interceptor (debug only)
    if (!Constant.inProduction) {
      interceptors.add(LoggingInterceptor());
    }

    /// add data format interceptor
    interceptors.add(AdapterInterceptor());
    configDio(
      baseUrl: AppConfig.serverUrl,
      interceptors: interceptors,
    );
  }

  ///
  /// Initialize after user authorize
  ///
  static Future<bool> initAfterAuthorize() async {
    // restore user related cache
    await UserProvider().restore();

    // try to start sync timer
    SyncTask.startTimer();

    final userInfo = UserProvider().profile.data;
    // whether cached user data exist or not
    return userInfo.email != null && userInfo.secretKey != null;
  }
}