import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:zpass/modules/user/cache/user_storage.dart';
import 'package:zpass/modules/user/model/user_setting_model.dart';

class UserSettings with UserStorage {
  static const String _userSettingKey = 'kUserSetting';

  late UserSettingModel _userSetting;
  UserSettingModel get data => _userSetting;

  set syncProvider(String value){
    _userSetting.syncProvider = value;
    flush();
  }
  set syncAccount(String account){
    _userSetting.syncAccount = account;
    flush();
  }
  set backupAndSync(bool status){
    _userSetting.backupAndSync = status;
    flush();
  }
  set backupDate(String? time){
    _userSetting.backupDate = time;
    flush();
  }
  set syncDate(String? time){
    _userSetting.syncDate = time;
    flush();
  }
  updateBackupDate(){
    _userSetting.backupDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    flush();
  }
  updateSyncDate(){
    _userSetting.syncDate = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    flush();
  }
  @override
  Future<dynamic> restore() async {
    final settingConfig = await read(_userSettingKey);
    if (settingConfig != null && settingConfig != '') {
      _userSetting = UserSettingModel.fromJson(jsonDecode(settingConfig));
    } else{
      _userSetting = UserSettingModel();
    }
    return read(_userSettingKey);
  }

  @override
  Future<dynamic> flush() {
    return write(_userSettingKey, jsonEncode(_userSetting));
  }

  @override
  Future<dynamic> clear() {
    _userSetting = UserSettingModel();
    return Future.value(null);
  }
}