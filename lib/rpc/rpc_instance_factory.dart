import 'package:zpass/util/log_utils.dart';

class RpcInstanceFactory {

  static final Map<String, Function> _mapping = <String, Function> {
  };

  static final Map<String, Function> _staticMethodMapping = <String, Function> {
  };

  static T create<T>(String clazz, dynamic data) {
    final createFunc = _mapping[clazz];
    if (createFunc == null) {
      final string = "clazz \"$clazz\" not found";
      throw(string);
    }
    return createFunc(data);
  }

  static Function? invokeMethod(String clazz, String method, dynamic data) {
    final func = _staticMethodMapping[clazz];
    Log.d("invokeMethod \"$clazz.$method($data)\" => $func");
    if (func == null) {
      throw("clazz \"$clazz\" not found");
    }
    return func;
  }
}