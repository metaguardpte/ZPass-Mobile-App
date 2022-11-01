import 'dart:convert';

import 'package:zpass/modules/user/cache/user_storage.dart';
import 'package:zpass/modules/user/model/user_crypto_key_model.dart';
import 'package:zpass/modules/user/model/user_info_model.dart';

class UserProfile with UserStorage {
  static const String _kUserProfile = 'zpass-mobile-userProfile';

  late UserInfoModel _userInfo;
  UserInfoModel get data => _userInfo;

  @override
  Future<dynamic> restore() async {
    final spData = await read(_kUserProfile);
    if (spData != null && spData != '') {
      _userInfo = UserInfoModel.fromJson(jsonDecode(spData));
    } else{
      _userInfo = UserInfoModel();
    }
  }

  @override
  Future<dynamic> flush() {
    return write(_kUserProfile, jsonEncode(_userInfo));
  }

  @override
  Future<dynamic> clear() {
    write(_kUserProfile, jsonEncode({}));
    return Future.value();
  }

  set userCryptoKey(UserCryptoKeyModel model) {
    _userInfo.userCryptoKey = model;
    flush();
  }

  set userEmail(String email) {
    _userInfo.email = email;
    flush();
  }

  set userSecretKey(String secretKey) {
    _userInfo.secretKey = secretKey;
    flush();
  }
}