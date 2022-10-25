import 'package:zpass/base/network/base_resp.dart';
import 'package:zpass/base/network/httpclient.dart';
import 'package:zpass/util/log_utils.dart';

class LoginServices {
  static const String _apiExtensionsSessionScanned = "/api/Extensions/session/scanned";
  static const String _apiExtensionsSessionApprove = "/api/Extensions/session/approve";
  static const String _apiExtensionsSessionReject = "/api/Extensions/session/reject";
  static const String _tag = "LoginServices";
  Future<dynamic> postExtensionsSessionScanned(String identity) {
    return HttpClient().requestNetwork(
      Method.post,
      _apiExtensionsSessionScanned,
      params: {
        "identity": identity,
      },
    ).catchError((error) {
      Log.e("post email verify code fail:${error.toString()}", tag: _tag);
      return Future.value(BaseResp(code: 400, message: "", data: "request fail"));
    });
  }
  Future<dynamic> postExtensionsSessionApprove(String identity) {
    return HttpClient().requestNetwork(
      Method.post,
      _apiExtensionsSessionApprove,
      params: {
        "identity": identity,
      },
    ).catchError((error) {
      Log.e("post email verify code fail:${error.toString()}", tag: _tag);
      return Future.value(BaseResp(code: 400, message: "", data: "request fail"));
    });
  }
  Future<dynamic> postExtensionsSessionReject(String identity) {
    return HttpClient().requestNetwork(
      Method.post,
      _apiExtensionsSessionReject,
      params: {
        "identity": identity,
      },
    ).catchError((error) {
      Log.e("post email verify code fail:${error.toString()}", tag: _tag);
      return Future.value(BaseResp(code: 400, message: "", data: "request fail"));
    });
  }

}