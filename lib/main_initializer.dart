import 'package:dio/dio.dart';
import 'package:sp_util/sp_util.dart';
import 'package:zpass/base/app_config.dart';
import 'package:zpass/base/network/httpclient.dart';
import 'package:zpass/base/network/intercept.dart';
import 'package:zpass/res/constant.dart';
import 'package:zpass/routers/routers.dart';
import 'package:zpass/rpc/rpc_manager.dart';
import 'package:zpass/util/log_utils.dart';

class MainInitializer {
  ///
  /// 用户未授权初始化
  ///
  /// IMPORTANT 请勿在此处添加任何需要用户权限授权的代码
  ///
  static Future<void> initBeforeAuthorize() async {
    // rpc通道初始化
    RpcManager.instance.startListening();
    // sp初始化
    await SpUtil.getInstance();
    // 初始化路由
    Routers.initRoutes();
    // 日志
    Log.init();
    // 网络
    _initDio();
  }

  static void _initDio() {
    final List<Interceptor> interceptors = <Interceptor>[];

    /// 统一添加身份验证请求头
    interceptors.add(AuthInterceptor());

    /// 刷新Token
    interceptors.add(TokenInterceptor());

    /// 打印Log(生产模式去除)
    if (!Constant.inProduction) {
      interceptors.add(LoggingInterceptor());
    }

    /// 适配数据(根据自己的数据结构，可自行选择添加)
    interceptors.add(AdapterInterceptor());
    configDio(
      baseUrl: AppConfig.serverUrl,
      interceptors: interceptors,
    );
  }

  ///
  /// 用户授权后初始化
  ///
  static void initAfterAuthorize() async {

  }
}