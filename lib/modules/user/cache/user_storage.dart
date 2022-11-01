import 'package:zpass/util/secure_storage.dart';

mixin UserStorage {
  Future<String?> read(String key) {
    return SecureStorage().read(key: key);
  }

  Future<dynamic> write(String key, String value) {
    return SecureStorage().write(key: key, value: value);
  }

  Future<dynamic> restore();

  Future<dynamic> flush();

  Future<dynamic> clear();
}