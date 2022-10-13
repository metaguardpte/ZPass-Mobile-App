import 'package:zpass/base/base_provider.dart';

class RegisterProvider extends BaseProvider {

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

}