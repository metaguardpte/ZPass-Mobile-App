import 'package:intl/intl.dart';

class LocalesUtils {
  static String message(String name) {
    return Intl.message(name, name: name);
  }
}