import 'dart:convert';

import 'package:sp_util/sp_util.dart';
import 'package:zpass/modules/setting/data_roaming/provider/sync_provider.dart';
import 'package:zpass/modules/user/model/user_crypto_key_model.dart';
import 'package:zpass/modules/user/model/user_info_model.dart';
import 'package:zpass/modules/user/model/user_setting_model.dart';
import 'package:zpass/util/secure_storage.dart';

class UserProvider {
  factory UserProvider() => _instance;
  static final UserProvider _instance = UserProvider._internal();
  static const String _kUserProviderKey = 'kUserProvider';
  static const String _signInListKey = 'signInList';
  static const String _kUserBiometrics = "kUserBiometrics";
  static const String _userSettingKey = 'kUserSetting';

  late UserInfoModel _userInfo;
  late UserSettingModel _userSetting;
  late Map<String , dynamic> _loginUserList;

  UserProvider._internal();

  Future<void> restore() async {
    final signInList = await SecureStorage().read(key: _signInListKey);
    final spData = await SecureStorage().read(key: _kUserProviderKey);
    final settingConfig = await SecureStorage().read(key: _userSettingKey);
    if (signInList != null && signInList != '') {
      _loginUserList = jsonDecode(signInList);
    } else{
      _loginUserList = {};
    }
    if (spData != null && spData != '') {
      _userInfo = UserInfoModel.fromJson(jsonDecode(spData));
    } else{
      _userInfo = UserInfoModel();
    }
    if (settingConfig != null && settingConfig != '') {
      _userSetting = UserSettingModel.fromJson(jsonDecode(settingConfig));
    } else{
      _userSetting = UserSettingModel();
    }
    // _dataRoaming
  }

  UserInfoModel get userInfo => _userInfo;
  UserSettingModel get userSetting => _userSetting;
  set syncProvider(String value){
    _userSetting.syncProvider = value;
  }

  set backupAndSync(bool status){
    _userSetting.backupAndSync = status;
    _flush_setting();
  }

  set userCryptoKey(UserCryptoKeyModel model) {
    _userInfo.userCryptoKey = model;
    _flush();
  }

  set userEmail(String email) {
    _userInfo.email = email;
    _flush();
  }

  set userName(String name) {
    _userInfo.name = name;
    _flush();
  }

  set userSecretKey(String secretKey) {
    _userInfo.secretKey = secretKey;
    _flush();
  }

  set userAvatar(String icon) {
    _userInfo.icon = icon;
    _flush();
  }

  void _flush() {
    SecureStorage().write(key: _kUserProviderKey, value: jsonEncode(_userInfo));
  }
  void _flush_setting(){
    SecureStorage().write(key: _userSettingKey, value: jsonEncode(_userSetting));
  }


  void updateSignInList(Map map) {
    _loginUserList[map['email']] = map['key'];
    SecureStorage().write(key: _signInListKey, value: jsonEncode(_loginUserList));
  }

  String? getUserKeyByEmail(String email) => _loginUserList[email];

  void clear(){
    _userInfo.userCryptoKey = UserCryptoKeyModel();
    _userSetting = UserSettingModel();
    _flush();
  }

  void putUserBiometrics(bool isOpen) {
    if (userInfo.email == null || userInfo.secretKey == null) return;
    SpUtil.putBool("${_kUserBiometrics}_${userInfo.email}", isOpen);
  }

  bool getUserBiometrics() {
    if (userInfo.email == null || userInfo.secretKey == null) return false;
    return SpUtil.getBool("${_kUserBiometrics}_${userInfo.email}") ?? false;
  }
}
