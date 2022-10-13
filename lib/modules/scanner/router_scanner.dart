import 'package:fluro/fluro.dart';
import 'package:fluro/src/fluro_router.dart';
import 'package:zpass/modules/scanner/scanner.dart';
import 'package:zpass/routers/i_router.dart';

class RouterScanner extends IRouterProvider {
  static String scanner = '/scanner';

  @override
  void initRouter(FluroRouter router) {
    router.define(scanner,
        handler: Handler(handlerFunc: (_, __) => const ScannerMode()));
  }
}
