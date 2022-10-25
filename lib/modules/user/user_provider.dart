import 'dart:convert';

import 'package:sp_util/sp_util.dart';
import 'package:zpass/modules/user/model/user_crypto_key_model.dart';
import 'package:zpass/modules/user/model/user_info_model.dart';

class UserProvider {
  factory UserProvider() => _instance;
  static final UserProvider _instance = UserProvider._internal();
  static const String _kUserProviderKey = 'kUserProvider';
  static const String _signInListKey = 'signInList';

  late UserInfoModel _userInfo;
  late Map<String , dynamic> _loginUserList;

  UserProvider._internal() {
    final signInList = SpUtil.getString(_signInListKey);
    final spData = SpUtil.getString(_kUserProviderKey);
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
  }

  UserInfoModel get userInfo => _userInfo;

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
    SpUtil.putString(_kUserProviderKey, jsonEncode(_userInfo));
  }

  void updateSignInList(Map map) {
    _loginUserList[map['email']] = map['key'];
    SpUtil.putString(_signInListKey, jsonEncode(_loginUserList));
  }

  String? getUserKeyByEmail(String email) => _loginUserList[email];

  void clear(){
    _userInfo.userCryptoKey = UserCryptoKeyModel();
    _flush();
  }
}
