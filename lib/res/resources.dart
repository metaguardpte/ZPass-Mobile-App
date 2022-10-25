import 'package:flutter/widgets.dart';
import 'package:zpass/widgets/load_image.dart';

export 'colors.dart';
export 'dimens.dart';
export 'gaps.dart';
export 'styles.dart';

class Images {
  static const Widget arrowRight = LoadAssetImage('ic_arrow_right', height: 16.0, width: 16.0);
}

const favicons = <String, String>{
  "facebook.com": "favicon/ic_facebook",
  "google.com": "favicon/ic_google",
  "instagram.com": "favicon/ic_instagram",
  "weibo.com": "favicon/ic_weibo",
  "youtube.com": "favicon/ic_youtube",
};

const faviconColorsGradient = {
  0: [Color(0xFF4077EA), Color(0xFF72B1FF)],
  1: [Color(0xFFEF6545), Color(0xFFF89E7B)],
  2: [Color(0xFFF38702), Color(0xFFFABE05)],
  3: [Color(0xFF4DA5FF), Color(0xFF70C8FF)],
  4: [Color(0xFFB083E4), Color(0xFFD8B9F3)],
};

const faviconColors = {
  0: Color(0xFFFF8A55),
  1: Color(0xFF3FD495),
  2: Color(0xFF007AF9),
  3: Color(0xFFFFAF31),
};