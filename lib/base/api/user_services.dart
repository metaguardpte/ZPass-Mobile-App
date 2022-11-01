import 'package:zpass/base/network/base_resp.dart';
import 'package:zpass/base/network/error_handle.dart';
import 'package:zpass/base/network/httpclient.dart';
import 'package:zpass/util/log_utils.dart';

class UserServices {
  static const String _apiProfile = "/api/me/UserProfile";

  static const String _tag = "UserServices";

  Future<BaseResp> getUserProfile() {
    return HttpClient().requestNetwork(
      Method.get,
      _apiProfile,
    ).catchError((error) {
      final netError = error as NetError;
      Log.e("getUserProfile fail: ${netError.msg}", tag: _tag);
      return Future.value(
          BaseResp(code: netError.code, message: netError.msg, data: null));
    });
  }
}
