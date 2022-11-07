import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:zpass/rpc/rpc_instance_factory.dart';
import 'package:zpass/rpc/rpc_instance_manager.dart';
import 'package:zpass/rpc/rpc_proxy.dart';
import 'package:zpass/util/log_utils.dart';

class RpcManager {
  static const rpcChannelId = "com.zpassapp.channels.RpcManager";

  static const rpcFuncInvoke = "invoke";
  static const rpcFuncNew = "new_instance";
  static const rpcFuncRelease = "release_instance";

  static const rpcParamInstance = "instance";
  static const rpcParamClass = "clazz";
  static const rpcParamMethod = "method";
  static const rpcParamData = "data";

  static const rpcOnChannelReady = "onChannelReady";
  static const rpcRcvCallback = "onInvoked";

  final MethodChannel _channel = const MethodChannel(rpcChannelId);

  static final RpcManager instance = RpcManager._internal();

  factory RpcManager() {
    return instance;
  }
  RpcManager._internal();

  void startPreLoad() {
    /// preload data here
  }

  void startListening() {
    _channel.setMethodCallHandler(_onMethodCall);
    _channel.invokeMethod(rpcOnChannelReady);
  }

  Future<dynamic> _onMethodCall(MethodCall call) {
    switch(call.method) {
      case rpcFuncRelease:
        return _rpcReleaseInstance(
            call.arguments[rpcParamInstance] as int
        );
      case rpcFuncNew:
        return _rpcNewInstance(
            call.arguments[rpcParamClass] as String,
            call.arguments[rpcParamData]
        );
      case rpcFuncInvoke:
        return _rpcInvoke(Map<String, dynamic>.from(call.arguments));
      default:
        return Future.value(null);
    }
  }

  Future<dynamic> _rpcInvoke(Map<String, dynamic> arguments) {
    if (arguments.containsKey(rpcParamInstance)) {
      return _rpcInvokeMethod(
          arguments[rpcParamInstance],
          arguments[rpcParamMethod],
          arguments[rpcParamData]
      );
    } else {
      return _rpcInvokeStaticMethod(
          arguments[rpcParamClass],
          arguments[rpcParamMethod],
          arguments[rpcParamData]
      );
    }
  }

  Future<dynamic> _rpcNewInstance(String clazz, dynamic data) {
    final id = RpcInstanceManager.shared.create(clazz, data);
    return Future.value(<String, dynamic>{
      rpcParamMethod: rpcFuncNew,
      rpcParamClass: clazz,
      rpcParamData: id
    });
  }

  Future<dynamic> _rpcReleaseInstance(int instanceId) {
    RpcInstanceManager.shared.disposeInstance(instanceId);
    return Future.value(
        <String, dynamic>{
          rpcParamMethod: rpcFuncRelease,
          rpcParamData: instanceId
        }
    );
  }

  Future<dynamic> _rpcInvokeMethod(int instanceId, String method, dynamic data) async {
    final proxy = RpcInstanceManager.shared.getInstance<RpcProxy>(instanceId);
    if (proxy == null) {
      return Future.value(null);
    }
    var resultData = await proxy.onMethodCall(method, data);
    String encodedData;
    if (resultData is String) {
      encodedData = resultData;
    } else {
      encodedData = const JsonEncoder().convert(resultData ?? {});
    }
    return Future.value(<String, dynamic> {
      rpcParamInstance: instanceId,
      rpcParamMethod: method,
      rpcParamData: encodedData
    });
  }

  Future<dynamic> _rpcInvokeStaticMethod(String clazz, String method, dynamic data) async {
    final call = RpcInstanceFactory.invokeMethod(clazz, method, data);
    if (call != null) {
      final resultData = await call(method, data);
      String encodedData;
      if (resultData is String) {
        encodedData = resultData;
      } else {
        encodedData = const JsonEncoder().convert(resultData ?? {});
      }
      return Future.value(<String, dynamic> {
        rpcParamClass: clazz,
        rpcParamMethod: method,
        rpcParamData: encodedData
      });
    }
    return null;
  }

  /// Dart to Native
  Future<dynamic> invoke(String clazz, String method, {dynamic args}) {
    var arguments = <String, dynamic> {
      rpcParamClass: clazz,
      rpcParamMethod: method,
    };
    if(args != null) {
      arguments[rpcParamData] = args;
    }
    if (Platform.isAndroid || Platform.isIOS) {
      return _invokeNativeMethod(rpcFuncInvoke, arguments);
    } else {
      //unsupported yet
      final tips = "rpc unsupported yet on ${Platform.operatingSystem}";
      Log.e(tips);
      return Future.value(tips);
    }
  }

  Future<dynamic> _invokeNativeMethod(String method, Map<String, dynamic> arguments) async {
    return _channel.invokeMethod(method, arguments);
  }
}