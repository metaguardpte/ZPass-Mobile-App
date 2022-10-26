import 'package:zpass/base/api/login_service.dart';
import 'package:zpass/util/log_utils.dart';

class SignInByScanner {
  final _loginRequest = LoginServices();

  Future<void> loginByQrCode(dynamic data) async {
    await _loginRequest.postExtensionsSessionScanned(data['identity']);
  }

  Future<void> postExtensionsSessionApprove(dynamic data) async {
    await _loginRequest.postExtensionsSessionApprove(data['identity']);
  }

  Future<void> postExtensionsSessionReject(dynamic data) async {
    await _loginRequest.postExtensionsSessionReject(data['identity']);
  }
}
