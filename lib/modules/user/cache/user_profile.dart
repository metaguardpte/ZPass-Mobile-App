import 'dart:convert';

import 'package:sp_util/sp_util.dart';
import 'package:zpass/base/api/user_services.dart';
import 'package:zpass/modules/user/cache/user_storage.dart';
import 'package:zpass/modules/user/model/user_crypto_key_model.dart';
import 'package:zpass/modules/user/model/user_info_model.dart';
import 'package:zpass/util/log_utils.dart';
import 'package:collection/collection.dart';

class UserProfile with UserStorage {
  static const String _kUserProfile = 'zpass-mobile-userProfile';
  static const String _kMainUser = "kMainUser";
  static const String _tag = 'UserProfile';

  late UserInfoModel _userInfo;
  UserInfoModel get data => _userInfo;

  List<UserInfoModel> _users = [];

  String _mainUserEmail = "";

  Future<bool> tryUpdate() {
    // if (_userInfo.userId >= 0) {
    //   Log.d("userinfo id: ${_userInfo.userId}, skip update", tag: _tag);
    //   return Future.value(false);
    // }
    return UserServices().getUserProfile().then((resp) {
      if (resp.isHttpOK() && !resp.hasError()) {
        Log.d("_fetchRemote user profile successfully", tag: _tag);
        final payload = resp.getPayload();
        Map<String, dynamic> temp = _userInfo.toJson();
        temp.addAll(payload);
        _userInfo = UserInfoModel.fromJson(temp);
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
    _mainUserEmail = SpUtil.getString(_kMainUser) ?? "";

    final spData = await read(_kUserProfile);
    if (spData != null && spData != '') {
      try {
        List<dynamic> temps = jsonDecode(spData);
        _users = temps.map((e) => UserInfoModel.fromJson(e)).toList();
        _userInfo = getMainUser() ?? UserInfoModel(userId: -1, userType: -1);
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
    final existModel = _users.firstWhereOrNull((element) => element.email == _userInfo.email);
    if (existModel != null) {
      _users.remove(existModel);
    }
    _users.add(_userInfo);
    return write(_kUserProfile, jsonEncode(_users.map((e) => e.toJson()).toList()));
  }

  @override
  Future<dynamic> clear() {
    return Future.value();
  }

  void setMainUser(String email) {
    _mainUserEmail = email;
    UserInfoModel? user = _users.firstWhereOrNull((element) => element.email == email);
    if (user == null) {
      user = UserInfoModel(userId: -1, userType: -1);
      user.email = email;
      _users.add(user);
    }
    _userInfo = user;
    _flushMainUser();
  }

  UserInfoModel? getMainUser({String? email}) {
    if (_users.isEmpty) return null;
    String currentEmail = email ?? _mainUserEmail;
    if (currentEmail.isEmpty) return _users.first;
    final user = _users.firstWhereOrNull((element) => element.email == currentEmail);
    if (user == null) {
      return _users.first;
    }
    return user;
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

  void _clearMainUser() {
    _mainUserEmail = "";
    SpUtil.remove(_kMainUser);
  }

  void _flushMainUser() {
    SpUtil.putString(_kMainUser, _mainUserEmail);
  }
}
