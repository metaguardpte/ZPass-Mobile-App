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

  /// ensure initialized
  WidgetsFlutterBinding.ensureInitialized();

  // force orientation portrait
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  Provider.debugCheckInvalidValueType = null;
  // initialize app before user authorize
  await MainInitializer.initBeforeAuthorize();

  /// handle uncaught error globally
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

    return OKToast(
        backgroundColor: Colors.black54,
        dismissOtherOnShow: true,
        duration: const Duration(seconds: 2),
        movingOnWindowChange: false,
        position: ToastPosition.center,
        radius: 5.0,
        textAlign: TextAlign.center,
        textPadding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        textStyle: const TextStyle(fontSize: 18, color: Colors.white),
        child: app);
  }

  Widget _buildMaterialApp(
      ThemeProvider provider, LocaleProvider localeProvider) {
    return MaterialApp(
      title: 'ZPass',
      // showPerformanceOverlay: true, // display performance overlay
      // debugShowCheckedModeBanner: false, // remove debug label
      // checkerboardRasterCacheImages: true,
      // showSemanticsDebugger: true, // display semantics debugger
      // checkerboardOffscreenLayers: true, // check board offscreen layer
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
        if (Device.isAndroid) {
          /// set theme for system navigation bar
          ThemeUtils.setSystemNavigationBar(provider.getThemeMode());
        }

        /// force text scale factor to 1.0
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: GestureDetector(
            child: child!,
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          ),
        );
      },

      onUnknownRoute: (_) {
        return MaterialPageRoute<void>(
          builder: (BuildContext context) => const NotFoundPage(),
        );
      },
      restorationScopeId: 'app',
    );
  }
}
