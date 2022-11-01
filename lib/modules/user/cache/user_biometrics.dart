import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:flutter/cupertino.dart';
import 'package:sp_util/sp_util.dart';
import 'package:zpass/modules/user/cache/user_storage.dart';
import 'package:zpass/modules/user/model/user_info_model.dart';
import 'package:zpass/modules/user/model/user_login_info_model.dart';

class UserBiometrics with UserStorage {
  static const String _kUserLoginInfo = "zpass-mobile-userLoginInfo";
  static const int _userRequirePasswordDefaultDay = 14;

  List<UserLoginInfoModel> _loginInfoList = [];
  late UserInfoModel _userInfo;

  void setUserInfo(UserInfoModel info) {
    _userInfo = info;
  }

  @protected
  List<String>? readList() {
    return SpUtil.getStringList(_kUserLoginInfo);
  }

  @protected
  Future<bool>? writeList() {
    final temp = _loginInfoList.map((e) => jsonEncode(e.toJson())).toList();
    return SpUtil.putStringList(_kUserLoginInfo, temp);
  }

  @override
  Future<dynamic> restore() {
    final List<String> loginInfoStr = readList() ?? [];
    if (loginInfoStr.isNotEmpty) {
      _loginInfoList = loginInfoStr.map((e) => UserLoginInfoModel.fromJson(jsonDecode(e))).toList();
    }
    return Future.value();
  }

  @override
  Future<dynamic> flush() {
    return writeList() ?? Future.error("can not write sp cache");
  }

  @override
  Future<dynamic> clear() {
    // don't clean biometrics cache
    return Future.value();
  }

  void putUserBiometrics(bool isOpen) {
    if (_userInfo.email == null || _userInfo.secretKey == null) return;
    UserLoginInfoModel infoModel = _getCurrentUserLoginInfo();
    infoModel.biometrics = isOpen;
    flush();
  }

  bool getUserBiometrics() {
    if (_userInfo.email == null || _userInfo.secretKey == null) return false;
    final result = _loginInfoList.firstWhereOrNull((element) => element.email == _userInfo.email);
    if (result == null) return false;
    return result.biometrics ?? false;
  }

  int getRequirePasswordDay() {
    if (_userInfo.email == null || _userInfo.secretKey == null) return _userRequirePasswordDefaultDay;
    final result = _loginInfoList.firstWhereOrNull((element) => element.email == _userInfo.email);
    if (result == null) return _userRequirePasswordDefaultDay;
    return result.requirePasswordDay ?? _userRequirePasswordDefaultDay;
  }

  void putRequirePasswordDay(int day) {
    if (_userInfo.email == null || _userInfo.secretKey == null) return;
    UserLoginInfoModel infoModel = _getCurrentUserLoginInfo();
    infoModel.requirePasswordDay = day;
    flush();
  }

  bool checkBiometricsIsExpired() {
    if (_userInfo.email == null || _userInfo.secretKey == null) return true;
    final result = _loginInfoList.firstWhereOrNull((element) => element.email == _userInfo.email);
    if (result == null) return true;
    if (result.lastLoginTime == null) return true;
    int inDays = DateTime.now().difference(result.lastLoginTime!).inDays;
    return inDays > result.requirePasswordDay!;
  }

  void putUserLastLoginTime(DateTime time) {
    if (_userInfo.email == null || _userInfo.secretKey == null) return;
    UserLoginInfoModel infoModel = _getCurrentUserLoginInfo();
    infoModel.lastLoginTime = time;
    flush();
  }

  UserLoginInfoModel _getCurrentUserLoginInfo() {
    UserLoginInfoModel? infoModel = _loginInfoList.firstWhereOrNull((element) => element.email == _userInfo.email);
    if (infoModel == null) {
      infoModel = UserLoginInfoModel(email: _userInfo.email!);
      _loginInfoList.add(infoModel);
    }
    return infoModel;
  }
}