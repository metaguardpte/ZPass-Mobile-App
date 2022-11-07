import 'package:flutter/foundation.dart';

class Constant {

  /// App run by Release，inProduction is true；App run by Debug or Profile，inProduction is false
  static const bool inProduction  = kReleaseMode;

  static bool isDriverTest  = false;
  static bool isUnitTest  = false;
  
  static const String data = 'data';
  static const String message = 'message';
  static const String code = 'code';
  
  static const String keyGuide = 'keyGuide';
  static const String phone = 'phone';
  static const String accessToken = 'accessToken';
  static const String refreshToken = 'refreshToken';

  static const String theme = 'app-theme';
  static const String locale = 'app-locale';

}
