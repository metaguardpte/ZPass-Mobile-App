import 'package:zpass/rpc/rpc_instance_factory.dart';

class RpcInstanceManager {
  int _index = 0;
  Map<int, dynamic> instances = <int, dynamic> {};

  static RpcInstanceManager? _instanceManager;

  static RpcInstanceManager get shared {
    _instanceManager ??= RpcInstanceManager();
    return _instanceManager!;
  }

  T? getInstance<T>(int instanceId) {
    if (instances.containsKey(instanceId)) {
      return instances[instanceId] as T;
    }
    return null;
  }

  void disposeInstance(int instanceId) {
    instances.remove(instanceId);
  }

  int create(String clazz, dynamic data) {
    dynamic instance = RpcInstanceFactory.create(clazz, data);
    int id = DateTime.now().millisecondsSinceEpoch << 4 + (++_index);
    instances[id] = instance;
    return id;
  }
}