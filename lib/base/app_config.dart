import 'package:flutter/foundation.dart';

class AppConfig {
  static String get userAgreementUrl => "https://www.zpassapp.com/zpass-app-user-service-agreement";
  static String get privacyNoticeUrl => "https://www.zpassapp.com/zpass-app-privacy-notice";

  static String get zpassWebsite => "www.zpassapp.com";
  static String get zpassEmail => "support@zpassapp.com";

  static const String _serverTest = "https://ro8d3r7nxb.execute-api.ap-southeast-1.amazonaws.com/Prod";
  static const String _serverDev = "https://l8ee0j8yb8.execute-api.ap-southeast-1.amazonaws.com/Prod";
  static String get serverUrl => kReleaseMode ? _serverTest : _serverTest;
}