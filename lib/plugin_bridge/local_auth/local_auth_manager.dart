import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:zpass/util/log_utils.dart';

class LocalAuthManager {
  factory LocalAuthManager() => _instance;
  static final LocalAuthManager _instance = LocalAuthManager._internal();

  late final LocalAuthentication _auth;
  final String _tag = "LocalAuthManager";

  LocalAuthManager._internal() {
    _auth = LocalAuthentication();
  }

  Future<List<BiometricType>> _getAvailableBiometrics() async {
    try {
      final List<BiometricType> results = await _auth.getAvailableBiometrics();
      Log.d("availableBiometrics is:${results.toString()}", tag: _tag);
      return results;
    } catch (e) {
      Log.d("get availableBiometrics fail:${e.toString()}", tag: _tag);
      return [];
    }
  }

  Future<bool> canAuth() async {
    try {
      final bool isDeviceSupported = await _auth.canCheckBiometrics && await _auth.isDeviceSupported();
      if (!isDeviceSupported) return false;

      final List<BiometricType> availableBiometrics = await _getAvailableBiometrics();
      return availableBiometrics.isNotEmpty;
    } catch (e) {
      Log.d("check can auth fail:${e.toString()}", tag: _tag);
      return Future.value(false);
    }
  }

  Future<bool> isSupportedFaceID() async {
    final List<BiometricType> availableBiometrics = await _getAvailableBiometrics();
    return availableBiometrics.isNotEmpty && availableBiometrics.contains(BiometricType.face);
  }

  Future<bool> isSupportedFingerprint() async {
    final List<BiometricType> availableBiometrics = await _getAvailableBiometrics();
    return availableBiometrics.isNotEmpty && availableBiometrics.contains(BiometricType.fingerprint);
  }

  Future<bool> authenticate() async {
    try {
      final result = await _auth.authenticate(
        localizedReason: "Unlock with Biometrics",
        options: const AuthenticationOptions(biometricOnly: true, useErrorDialogs: false),
      );
      return result;
    } on PlatformException catch(e) {
      Log.e("authenticate fail, code:${e.code}, message:${e.message}", tag: _tag);
      return Future.value(false);
    }
  }

  Future<bool> cancelAuthenticate() async {
    try {
      final result = await _auth.stopAuthentication();
      return result;
    } catch(e) {
      Log.e("stop authenticate fail:${e.toString()}", tag: _tag);
      return Future.value(false);
    }
  }

}