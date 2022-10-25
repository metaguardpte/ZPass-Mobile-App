import 'package:zpass/base/network/base_resp.dart';
import 'package:zpass/base/network/httpclient.dart';
import 'package:zpass/util/log_utils.dart';

class RegisterServices {
  static const String apiUserRegistration = "/api/Users/registration";
  static const String apiActivation = "/api/Activation";

  static const String _tag = "RegisterService";

  Future<dynamic> postEmailVerifyCode(String email, int planType) {
    return HttpClient().requestNetwork(
        Method.post,
        apiUserRegistration,
        params: {
          "accountType": planType,
          "email": email,
          "timezone": "Asia/Shanghai"
        },
    ).catchError((error) {
      Log.e("post email verify code fail:${error.toString()}", tag: _tag);
      return Future.value(BaseResp(code: 400, message: "", data: "request fail"));
    });
  }

  Future<dynamic> checkEmailVerifyCode(String email, String code) {
    return HttpClient().requestNetwork(
        Method.get,
        apiActivation,
        queryParameters: {"email": email, "code": code},
    ).catchError((error) {
      Log.e("check email verify code fail:${error.toString()}", tag: _tag);
      return Future.value(BaseResp(code: 400, message: "", data: "request fail"));
    });
  }

  Future<dynamic> activationAccount(Map<String, dynamic> data) {
    return HttpClient()
        .requestNetwork(Method.post, apiActivation, params: data)
        .catchError((error) {
          Log.e("activation account fail:${error.toString()}", tag: _tag);
          return Future.value(BaseResp(code: 400, message: "", data: "request fail"));
      },
    );
  }
}