import 'package:zpass/base/base_provider.dart';

class SettingProvider extends BaseProvider {

  String _userRequirePassword = "";
  String get userRequirePassword => _userRequirePassword;
  set userRequirePassword(String day) {
    _userRequirePassword = day;
    notifyListeners();
  }

}