import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:zpass/util/log_utils.dart';

enum ConnectivityStatus {
  /// WiFi: Device connected via Wi-Fi
  wifi,

  /// Mobile: Device connected to cellular network
  mobile,

  /// None: Device not connected to any network
  none,

  /// Unknown
  unknown
}

class ConnectivityProvider extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();

  ConnectivityStatus _connectionStatus = ConnectivityStatus.unknown;
  StreamSubscription<ConnectivityResult>? _subscription;

  ConnectivityStatus get status => _connectionStatus;

  ConnectivityProvider._internal();
  factory ConnectivityProvider() => _instance;
  static final ConnectivityProvider _instance = ConnectivityProvider._internal();

  initAfterUserAuthorized() {
    if(_connectionStatus == ConnectivityStatus.unknown) {
      // Platform messages may fail, so we use a try/catch PlatformException.
      try {
        _connectivity.checkConnectivity().then((value) =>
            _updateConnectionStatus(value));
      } on PlatformException catch (e) {
        //
      }
    }

    _subscription ??= _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    ConnectivityStatus? connectionStatus;
    switch (result) {
      case ConnectivityResult.wifi:
        connectionStatus = ConnectivityStatus.wifi;
        break;
      case ConnectivityResult.mobile:
        connectionStatus = ConnectivityStatus.mobile;
        break;
      case ConnectivityResult.none:
        connectionStatus = ConnectivityStatus.none;
        break;
      default:
        break;
    }

    if(connectionStatus != null && connectionStatus != _connectionStatus) {
      Log.d("connection changed: ${_connectionStatus.toString()} => ${connectionStatus.toString()}");
      _connectionStatus = connectionStatus;
      notifyListeners();
    }
  }
}