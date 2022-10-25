import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:zpass/main_initializer.dart';
import 'package:zpass/modules/home/splash_page.dart';
import 'package:zpass/modules/setting/provider/connectivity_provider.dart';
import 'package:zpass/modules/setting/provider/locale_provider.dart';
import 'package:zpass/modules/setting/provider/theme_provider.dart';
import 'package:zpass/routers/not_found_page.dart';
import 'package:zpass/routers/router_observer.dart';
import 'package:zpass/routers/routers.dart';
import 'package:zpass/util/device_utils.dart';
import 'package:zpass/util/handle_error_utils.dart';
import 'package:zpass/util/theme_utils.dart';
import 'generated/l10n.dart';

Future<void> main() async {
//  debugProfileBuildsEnabled = true;
//  debugPaintLayerBordersEnabled = true;
//  debugProfilePaintsEnabled = true;
//  debugRepaintRainbowEnabled = true;

  /// 确保初始化完成
  WidgetsFlutterBinding.ensureInitialized();

  // 强制竖屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Provider.debugCheckInvalidValueType = null;
  //不申请任何权限的最小同步初始化
  await MainInitializer.initBeforeAuthorize();

  /// 异常处理
  handleError(() => runApp(const MyApp()));
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
        builder:
            (_, ThemeProvider provider, LocaleProvider localeProvider, __) {
          return _buildMaterialApp(provider, localeProvider);
        },
      ),
    );

    /// Toast 配置
    return OKToast(
        backgroundColor: Colors.black54,
        textPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        radius: 20.0,
        position: ToastPosition.bottom,
        child: app);
  }

  Widget _buildMaterialApp(
      ThemeProvider provider, LocaleProvider localeProvider) {
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
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      supportedLocales: S.delegate.supportedLocales,
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
          child: GestureDetector(
            child: child!,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          ),
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
