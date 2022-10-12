abstract class RpcProxy {
  Future<dynamic> onMethodCall(String method, dynamic args);
}