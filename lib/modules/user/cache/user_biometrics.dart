import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:flutter/cupertino.dart';
import 'package:sp_util/sp_util.dart';
import 'package:zpass/modules/user/cache/user_storage.dart';
import 'package:zpass/modules/user/model/user_info_model.dart';
import 'package:zpass/modules/user/model/user_login_info_model.dart';

class UserBiometrics with UserStorage {
  static const String _kUserLoginInfo = "zpass-mobile-userLoginInfo";
  static const int _userRequirePasswordDefaultDay = 7;

  List<UserLoginInfoModel> _loginInfoList = [];
  // late UserInfoModel _userInfo;

  void setUserInfo(UserInfoModel info) {
    // _userInfo = info;
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

  void putUserBiometrics(bool isOpen, String email) {
    UserLoginInfoModel infoModel = _getCurrentUserLoginInfo(email);
    infoModel.biometrics = isOpen;
    flush();
  }

  bool getUserBiometrics(String email) {
    final result = _loginInfoList.firstWhereOrNull((element) => element.email == email);
    if (result == null) return false;
    return result.biometrics ?? false;
  }

  int getRequirePasswordDay(String email) {
    final result = _loginInfoList.firstWhereOrNull((element) => element.email == email);
    if (result == null) return _userRequirePasswordDefaultDay;
    return result.requirePasswordDay ?? _userRequirePasswordDefaultDay;
  }

  void putRequirePasswordDay(String email, int day) {
    UserLoginInfoModel infoModel = _getCurrentUserLoginInfo(email);
    infoModel.requirePasswordDay = day;
    flush();
  }

  bool checkBiometricsIsExpired(String email) {
    final result = _loginInfoList.firstWhereOrNull((element) => element.email == email);
    if (result == null) return true;
    if (result.lastLoginTime == null) return true;
    int inDays = DateTime.now().difference(result.lastLoginTime!).inDays;
    return inDays > result.requirePasswordDay!;
  }

  void putUserLastLoginTime(DateTime time, String email) {
    UserLoginInfoModel infoModel = _getCurrentUserLoginInfo(email);
    infoModel.lastLoginTime = time;
    flush();
  }

  UserLoginInfoModel _getCurrentUserLoginInfo(String email) {
    UserLoginInfoModel? infoModel = _loginInfoList.firstWhereOrNull((element) => element.email == email);
    if (infoModel == null) {
      infoModel = UserLoginInfoModel(email: email ?? "");
      _loginInfoList.add(infoModel);
    }
    return infoModel;
  }
}