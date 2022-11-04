import 'package:zpass/modules/user/cache/user_biometrics.dart';
import 'package:zpass/modules/user/cache/user_profile.dart';
import 'package:zpass/modules/user/cache/user_secret_keys.dart';
import 'package:zpass/modules/user/cache/user_settings.dart';
import 'package:zpass/util/log_utils.dart';

class UserProvider {
  factory UserProvider() => _instance;
  static final UserProvider _instance = UserProvider._internal();
  static const String _tag = "UserProvider";

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
    await _secretKeys
        .restore()
        .catchError((e) => Log.d("restore secret keys failed: $e", tag: _tag));
    await _biometrics
        .restore()
        .catchError((e) => Log.d("restore biometrics failed: $e", tag: _tag));
    await _profile
        .restore()
        .catchError((e) => Log.d("restore profile failed: $e", tag: _tag));
    await _settings
        .restore()
        .catchError((e) => Log.d("restore settings failed: $e", tag: _tag));

    _biometrics.setUserInfo(_profile.data);
  }
  void clear() {
    _secretKeys.clear();
    _biometrics.clear();
    _profile.clear();
  }
}
