import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:sp_util/sp_util.dart';
import 'package:zpass/base/network/httpclient.dart';
import 'package:zpass/base/network/intercept.dart';
import 'package:zpass/modules/home/splash_page.dart';
import 'package:zpass/modules/setting/provider/connectivity_provider.dart';
import 'package:zpass/modules/setting/provider/locale_provider.dart';
import 'package:zpass/modules/setting/provider/theme_provider.dart';
import 'package:zpass/res/constant.dart';
import 'package:zpass/routers/not_found_page.dart';
import 'package:zpass/routers/router_observer.dart';
import 'package:zpass/routers/routers.dart';
import 'package:zpass/util/device_utils.dart';
import 'package:zpass/util/handle_error_utils.dart';
import 'package:zpass/util/log_utils.dart';
import 'package:flutter_gen/gen_l10n/zpass_localizations.dart';
import 'package:zpass/util/theme_utils.dart';

Future<void> main() async {
//  debugProfileBuildsEnabled = true;
//  debugPaintLayerBordersEnabled = true;
//  debugProfilePaintsEnabled = true;
//  debugRepaintRainbowEnabled = true;

  /// 确保初始化完成
  WidgetsFlutterBinding.ensureInitialized();

  //不申请任何权限的最小同步初始化
  await _initAheadOfWorld();

  /// 1.22 预览功能: 在输入频率与显示刷新率不匹配情况下提供平滑的滚动效果
  // GestureBinding.instance?.resamplingEnabled = true;
  /// 异常处理
  handleError(() => runApp(const MyApp()));

  /// 隐藏状态栏。为启动页、引导页设置。完成后修改回显示状态栏。
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom]);
  // 相关问题跟踪：https://github.com/flutter/flutter/issues/73351
}

///
/// IMPORTANT 请勿在此处添加任何需要用户权限授权的代码
///
Future<void> _initAheadOfWorld() async {
  // 强制竖屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  Provider.debugCheckInvalidValueType = null;

  // sp初始化
  await SpUtil.getInstance();
  // 初始化路由
  Routers.initRoutes();
  // 日志
  Log.init();
  // 网络
  _initDio();
}

void _initDio() {
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
    baseUrl: 'https://api.github.com/',
    interceptors: interceptors,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, this.home, this.theme});

  final Widget? home;
  final ThemeData? theme;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final Widget app = MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (_, ThemeProvider provider, LocaleProvider localeProvider, __) {
          return _buildMaterialApp(provider, localeProvider);
        },
      ),
    );

    /// Toast 配置
    return OKToast(
        backgroundColor: Colors.black54,
        textPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        radius: 20.0,
        position: ToastPosition.bottom,
        child: app
    );
  }

  Widget _buildMaterialApp(ThemeProvider provider, LocaleProvider localeProvider) {
    return MaterialApp(
      title: 'ZPass',
      // showPerformanceOverlay: true, //显示性能标签
      // debugShowCheckedModeBanner: false, // 去除右上角debug的标签
      // checkerboardRasterCacheImages: true,
      // showSemanticsDebugger: true, // 显示语义视图
      // checkerboardOffscreenLayers: true, // 检查离屏渲染
      theme: theme ?? provider.getTheme(),
      darkTheme: provider.getTheme(isDarkMode: true),
      themeMode: provider.getThemeMode(),
      home: home ?? const SplashPage(),
      onGenerateRoute: Routers.router.generator,
      localizationsDelegates: ZPassLocalizations.localizationsDelegates,
      supportedLocales: ZPassLocalizations.supportedLocales,
      locale: localeProvider.locale,
      navigatorKey: navigatorKey,
      navigatorObservers: [
        RouterObserver(),
      ],
      builder: (BuildContext context, Widget? child) {
        /// 仅针对安卓
        if (Device.isAndroid) {
          /// 切换深色模式会触发此方法，这里设置导航栏颜色
          ThemeUtils.setSystemNavigationBar(provider.getThemeMode());
        }

        /// 保证文字大小不受手机系统设置影响 https://www.kikt.top/posts/flutter/layout/dynamic-text/
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },

      /// 因为使用了fluro，这里设置主要针对Web
      onUnknownRoute: (_) {
        return MaterialPageRoute<void>(
          builder: (BuildContext context) => const NotFoundPage(),
        );
      },
      restorationScopeId: 'app',
    );
  }
}
