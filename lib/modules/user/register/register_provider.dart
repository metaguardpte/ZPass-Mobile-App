import 'package:dio/dio.dart';
import 'package:zpass/base/api/register_services.dart';
import 'package:zpass/base/base_provider.dart';
import 'package:zpass/base/network/base_resp.dart';

class RegisterProvider extends BaseProvider {

  final _remote = RegisterServices();

  /// register basic information block
  // email code loading state
  bool _emailCodeLoading = false;
  bool get emailCodeLoading => _emailCodeLoading;
  set emailCodeLoading(bool value) {
    _emailCodeLoading = value;
    notifyListeners();
  }

  // email code show state
  bool _visibleEmailVerifyCode = false;
  bool get visibleEmailVerifyCode => _visibleEmailVerifyCode;
  set visibleEmailVerifyCode(bool value) {
    _visibleEmailVerifyCode = value;
    notifyListeners();
  }

  // plan type
  int _planTypeIndex = 0;
  int get planTypeIndex => _planTypeIndex;
  set planTypeIndex(int value) {
    _planTypeIndex = value;
    notifyListeners();
  }


  /// register page block
  // loading state
  bool _loading = false;
  bool get loading => _loading;
  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  // 注册步骤索引
  int _stepIndex = 0;
  int get stepIndex => _stepIndex;
  set stepIndex(int index) {
    _stepIndex = index;
    notifyListeners();
  }

  // email
  String _email = "";
  String get email => _email;
  set email(String value) {
    _email = value;
    notifyListeners();
  }

  // code
  String _emailVerifyCode = "";
  String get emailVerifyCode => _emailVerifyCode;
  set emailVerifyCode(String value) {
    _emailVerifyCode = value;
    notifyListeners();
  }

  // checkbox state
  bool _protocolChecked = false;
  bool get protocolChecked => _protocolChecked;
  set protocolChecked(bool value) {
    _protocolChecked = value;
  }

  /// api request
  Future<String?> doGetEmailVerifyCode() async {
    emailCodeLoading = true;
    final BaseResp resp = await _remote.postEmailVerifyCode(email, planTypeIndex + 1);
    emailCodeLoading = false;
    if (resp.isHttpOK()) {
      if (resp.hasError()) {
        return Future.value(resp.getError()["id"]);
      }
      visibleEmailVerifyCode = true;
      return Future.value(null);
    } else {
      return Future.value(resp.data.toString());
    }
  }

  Future<String?> doCheckEmailVerifyCode() async {
    loading = true;
    final BaseResp resp = await _remote.checkEmailVerifyCode(email, emailVerifyCode);
    loading = false;
    if (resp.isHttpOK()) {
      if (resp.hasError()) {
        return Future.value(resp.getError()["id"]);
      }
      return Future.value(null);
    } else {
      return Future.value(resp.data.toString());
    }
  }

}