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
  late Map<String , String> _loginUserList;
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
  void clear(){
    _userInfo.userCryptoKey = UserCryptoKeyModel();
    SpUtil.putString(_kUserProviderKey, jsonEncode(_userInfo));
  }
  void updateUserCryptoKey(UserCryptoKeyModel raw) {
    _userInfo.userCryptoKey = raw;
    SpUtil.putString(_kUserProviderKey, jsonEncode(_userInfo));
  }
  void updateEmail(String email) {
    _userInfo.email = email;
    SpUtil.putString(_kUserProviderKey, jsonEncode(_userInfo));
  }

  void updateName(String name) {
    _userInfo.name = name;
    SpUtil.putString(_kUserProviderKey, jsonEncode(_userInfo));
  }

  void updateSecretKey(String secretKey) {
    _userInfo.secretKey = secretKey;
    SpUtil.putString(_kUserProviderKey, jsonEncode(_userInfo));
  }

  void updateIcon(String icon) {
    _userInfo.icon = icon;
    SpUtil.putString(_kUserProviderKey, jsonEncode(_userInfo));
  }

  UserInfoModel getUserInfo(){
    return _userInfo;
  }

  void updateSignInList(Map map) {
    _loginUserList[map['email']] = map['key'];
    SpUtil.putString(_signInListKey, jsonEncode(_loginUserList));
  }

  String? getUserKeyByEmail(String email){
    print(_loginUserList);
    print('_loginUserList');
    var key = _loginUserList[email];
    return key ?? null;
  }
}
