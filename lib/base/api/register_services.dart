import 'package:zpass/base/network/base_resp.dart';
import 'package:zpass/base/network/httpclient.dart';

class RegisterServices {
  static const String apiUserRegistration = "/api/Users/registration";
  static const String apiActivation = "/api/Activation";

  Future<dynamic> postEmailVerifyCode(String email, int planType) {
    return HttpClient().requestNetwork(
        Method.post,
        apiUserRegistration,
        params: {
          "accountType": planType,
          "email": email,
          "timezone": "Asia/Shanghai"
        },
    );
  }

  Future<dynamic> checkEmailVerifyCode(String email, String code) {
    return HttpClient().requestNetwork(
        Method.get,
        apiActivation,
        queryParameters: {"email": email, "code": code},
    );
  }

  Future<dynamic> activationAccount(Map<String, dynamic> data) {
    return HttpClient().requestNetwork(Method.post, apiActivation, params: data);
  }

}