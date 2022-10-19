import 'dart:convert';

import 'package:sp_util/sp_util.dart';
import 'package:zpass/modules/user/model/user_crypto_key_model.dart';
import 'package:zpass/modules/user/model/user_info_model.dart';

class UserProvider {
  static UserProvider get _instance => UserProvider._internal();
  static const String _kUserProviderKey = 'kUserProvider';

  late UserInfoModel _userInfo;

  factory UserProvider() {
    return _instance;
  }

  UserProvider._internal() {
    final spData = SpUtil.getString(_kUserProviderKey);
    print('object---------------${spData}');
    if (spData != null && spData != '') {
      _userInfo = UserInfoModel.fromJson(jsonDecode(spData));
      print('_userInfo ---- ${_userInfo}');
    } else{
      _userInfo = UserInfoModel();
    }
  }
  void clear(){
    _userInfo = UserInfoModel();
    SpUtil.putString(_kUserProviderKey, jsonEncode(_userInfo));
  }
  void updateUserCryptoKey(UserCryptoKeyModel raw) {
    _userInfo.userCryptoKey = raw;
    SpUtil.putString(_kUserProviderKey, jsonEncode(_userInfo));
  }
  void updateEmail(String email) {
    print('123123123');
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
}
