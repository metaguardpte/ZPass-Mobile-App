import 'package:zpass/modules/user/cache/user_biometrics.dart';
import 'package:zpass/modules/user/cache/user_profile.dart';
import 'package:zpass/modules/user/cache/user_secret_keys.dart';
import 'package:zpass/modules/user/cache/user_settings.dart';

class UserProvider {
  factory UserProvider() => _instance;
  static final UserProvider _instance = UserProvider._internal();

  late final UserProfile _profile;
  late final UserSettings _settings;
  late final UserBiometrics _biometrics;
  late final UserSecretKeys _secretKeys;

  UserProfile get profile => _profile;
  UserSecretKeys get secretKeys => _secretKeys;
  UserSettings get settings => _settings;
  UserBiometrics get biometrics => _biometrics;

  UserProvider._internal() {
    _profile = UserProfile();
    _settings = UserSettings();
    _biometrics = UserBiometrics();
    _secretKeys = UserSecretKeys();
  }

  Future<void> restore() async {
    await _secretKeys.restore();
    await _biometrics.restore();
    await _profile.restore();
    await _settings.restore();

    _biometrics.setUserInfo(_profile.data);
  }

  void clear() {
    _settings.clear();
    _secretKeys.clear();
    _biometrics.clear();
    _profile.clear();
  }
}
