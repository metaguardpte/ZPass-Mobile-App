import 'dart:convert';

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

  set backupAndSync(bool status){
    _userSetting.backupAndSync = status;
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