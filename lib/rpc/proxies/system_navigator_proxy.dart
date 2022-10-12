import 'package:zpass/rpc/rpc_manager.dart';

class SystemNavigatorProxy {
  static const String _class = "SystemNavigatorProxy";
  static const String _mPop = "SystemNavigator.pop";
  static const String _mExit = "SystemNavigator.exit";

  static Future<dynamic> pop() {
    return RpcManager.instance.invoke(_class, _mPop);
  }

  static Future<dynamic> exit() {
    return RpcManager.instance.invoke(_class, _mExit);
  }
}