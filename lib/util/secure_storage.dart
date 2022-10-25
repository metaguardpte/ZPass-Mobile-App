import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static SecureStorage? instance;

  static init() {
    instance = SecureStorage._();
  }

  IOSOptions _iOptions() => const IOSOptions(
      accountName: 'zero-pass'
  );
  AndroidOptions _aOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
    sharedPreferencesName: 'zero-pass'
  );
  final _storage = const FlutterSecureStorage();

  SecureStorage._();

  Future<void> write({
    required String key,
    required String? value
  }) {
    return _storage.write(key: key, value: value, iOptions: _iOptions(), aOptions: _aOptions());
  }

  Future<String?> read({
    required String key,
  }) {
    return _storage.read(key: key, iOptions: _iOptions(), aOptions: _aOptions());
  }

  Future<bool> containsKey({
    required String key,
  }) {
    return _storage.containsKey(key: key, iOptions: _iOptions(), aOptions: _aOptions());
  }

  Future<void> delete({
    required String key,
  }) {
    return _storage.delete(key: key, iOptions: _iOptions(), aOptions: _aOptions());
  }
}