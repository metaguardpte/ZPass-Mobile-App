import 'package:flutter/foundation.dart';

class AppConfig {
  static String get userAgreementUrl => "https://www.zpassapp.com/zpass-app-user-service-agreement";
  static String get privacyNoticeUrl => "https://www.zpassapp.com/zpass-app-privacy-notice";

  static String get zpassWebsite => "www.zpassapp.com";
  static String get zpassEmail => "support@zpassapp.com";
  static String get zpassDownloadUrl => "https://$zpassWebsite/download";

  static const String _serverTest = "https://ro8d3r7nxb.execute-api.ap-southeast-1.amazonaws.com/Prod";
  static const String _serverDev = "https://l8ee0j8yb8.execute-api.ap-southeast-1.amazonaws.com/Prod";
  static const String _serverPre = "https://i3j0hcc2q7.execute-api.ap-southeast-1.amazonaws.com/Prod";
  static const String _serverProduct = "https://zv42of7gd4.execute-api.ap-southeast-1.amazonaws.com";
  static String get serverUrl => kReleaseMode ? _serverTest : _serverTest;
}