import 'dart:convert';

import 'package:zpass/base/api/user_services.dart';
import 'package:zpass/modules/user/cache/user_storage.dart';
import 'package:zpass/modules/user/model/user_crypto_key_model.dart';
import 'package:zpass/modules/user/model/user_info_model.dart';
import 'package:zpass/util/log_utils.dart';

class UserProfile with UserStorage {
  static const String _kUserProfile = 'zpass-mobile-userProfile';
  static const String _tag = 'UserProfile';

  late UserInfoModel _userInfo;
  UserInfoModel get data => _userInfo;

  Future<bool> tryUpdate() {
    // if (_userInfo.userId >= 0) {
    //   Log.d("userinfo id: ${_userInfo.userId}, skip update", tag: _tag);
    //   return Future.value(false);
    // }
    return UserServices().getUserProfile().then((resp) {
      if (resp.isHttpOK() && !resp.hasError()) {
        Log.d("_fetchRemote user profile successfully", tag: _tag);
        _userInfo = UserInfoModel.fromJson(resp.getPayload());
        flush();
        return true;
      } else {
        Log.d("failed to fetch user profile from server", tag: _tag);
        return false;
      }
    });
  }

  @override
  Future<dynamic> restore() async {
    final spData = await read(_kUserProfile);
    if (spData != null && spData != '') {
      try {
        _userInfo = UserInfoModel.fromJson(jsonDecode(spData));
      } catch (e) {
        _userInfo = UserInfoModel(userId: -1, userType: -1);
        rethrow;
      }
    } else {
      _userInfo = UserInfoModel(userId: -1, userType: -1);
      throw StateError("no user profile cache");
    }
  }

  @override
  Future<dynamic> flush() {
    return write(_kUserProfile, jsonEncode(_userInfo));
  }

  @override
  Future<dynamic> clear() {
    // write(_kUserProfile, jsonEncode({}));
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
