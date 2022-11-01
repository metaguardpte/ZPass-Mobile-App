import 'dart:convert';

import 'package:sp_util/sp_util.dart';
import 'package:zpass/modules/setting/data_roaming/provider/sync_provider.dart';
import 'package:zpass/modules/user/model/user_crypto_key_model.dart';
import 'package:zpass/modules/user/model/user_info_model.dart';
import 'package:zpass/modules/user/model/user_setting_model.dart';
import 'package:zpass/modules/user/model/user_login_info_model.dart';
import 'package:zpass/util/secure_storage.dart';
import 'package:collection/collection.dart';

class UserProvider {
  factory UserProvider() => _instance;
  static final UserProvider _instance = UserProvider._internal();
  static const String _kUserProviderKey = 'kUserProvider';
  static const String _signInListKey = 'signInList';
  static const String _userSettingKey = 'kUserSetting';
  static const String _kUserLoginInfo = "kUserLoginInfo";
  static const int _userRequirePasswordDefaultDay = 14;

  late UserInfoModel _userInfo;
  late UserSettingModel _userSetting;
  late Map<String , dynamic> _loginUserList;
  List<UserLoginInfoModel> _loginInfoList = [];

  UserProvider._internal();

  Future<void> restore() async {
    final signInList = await SecureStorage().read(key: _signInListKey);
    final spData = await SecureStorage().read(key: _kUserProviderKey);
    final settingConfig = await SecureStorage().read(key: _userSettingKey);
    final List<String> loginInfoStr = SpUtil.getStringList(_kUserLoginInfo) ?? [];
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
    if (loginInfoStr.isNotEmpty) {
      _loginInfoList = loginInfoStr.map((e) => UserLoginInfoModel.fromJson(jsonDecode(e))).toList();
    }
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
    _userSetting = UserSettingModel();
    // _userInfo.userCryptoKey = UserCryptoKeyModel();
    // _flush();
  }

  void _flushUserLoginInfo() {
    final temp = _loginInfoList.map((e) => jsonEncode(e.toJson())).toList();
    SpUtil.putStringList(_kUserLoginInfo, temp);
  }

  void putUserBiometrics(bool isOpen) {
    if (userInfo.email == null || userInfo.secretKey == null) return;
    UserLoginInfoModel infoModel = _getCurrentUserLoginInfo();
    infoModel.biometrics = isOpen;
    _flushUserLoginInfo();
  }

  bool getUserBiometrics() {
    if (userInfo.email == null || userInfo.secretKey == null) return false;
    final result = _loginInfoList.firstWhereOrNull((element) => element.email == userInfo.email);
    if (result == null) return false;
    return result.biometrics ?? false;
  }

  int getRequirePasswordDay() {
    if (userInfo.email == null || userInfo.secretKey == null) return _userRequirePasswordDefaultDay;
    final result = _loginInfoList.firstWhereOrNull((element) => element.email == userInfo.email);
    if (result == null) return _userRequirePasswordDefaultDay;
    return result.requirePasswordDay ?? _userRequirePasswordDefaultDay;
  }

  void putRequirePasswordDay(int day) {
    if (userInfo.email == null || userInfo.secretKey == null) return;
    UserLoginInfoModel infoModel = _getCurrentUserLoginInfo();
    infoModel.requirePasswordDay = day;
    _flushUserLoginInfo();
  }

  bool checkBiometricsIsExpired() {
    if (userInfo.email == null || userInfo.secretKey == null) return true;
    final result = _loginInfoList.firstWhereOrNull((element) => element.email == userInfo.email);
    if (result == null) return true;
    if (result.lastLoginTime == null) return true;
    int inDays = DateTime.now().difference(result.lastLoginTime!).inDays;
    return inDays > result.requirePasswordDay!;
  }

  void putUserLastLoginTime(DateTime time) {
    if (userInfo.email == null || userInfo.secretKey == null) return;
    UserLoginInfoModel infoModel = _getCurrentUserLoginInfo();
    infoModel.lastLoginTime = time;
    _flushUserLoginInfo();
  }

  UserLoginInfoModel _getCurrentUserLoginInfo() {
    UserLoginInfoModel? infoModel = _loginInfoList.firstWhereOrNull((element) => element.email == userInfo.email);
    if (infoModel == null) {
      infoModel = UserLoginInfoModel(email: userInfo.email!);
      _loginInfoList.add(infoModel);
    }
    return infoModel;
  }

}
