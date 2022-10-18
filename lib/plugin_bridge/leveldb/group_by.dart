
import 'package:zpass/plugin_bridge/leveldb/record_entity.dart';



abstract class KeyFunc {
  String getKey(int time);
  bool match(int time);
  int getOrder();
}

class TodayKeyFunc implements KeyFunc {

  @override
  String getKey(int time) {
    return "TODAY";
  }

  @override
  bool match(int time) {
    throw UnimplementedError();
  }

  @override
  int getOrder() {
    return 0;
  }
}

class YesterdayKeyFunc implements KeyFunc {

  @override
  String getKey(int time) {
    return "YESTERDAY";
  }

  @override
  bool match(int time) {
    throw UnimplementedError();
  }

  @override
  int getOrder() {
    return 1;
  }
}

class WeekKeyFunc implements KeyFunc {

  @override
  String getKey(int time) {
    return "WEEK";
  }

  @override
  bool match(int time) {
    throw UnimplementedError();
  }

  @override
  int getOrder() {
    return 2;
  }
}

class MonthKeyFunc implements KeyFunc {

  @override
  String getKey(int time) {
    throw UnimplementedError();
  }

  @override
  bool match(int time) {
    throw UnimplementedError();
  }

  @override
  int getOrder() {
    return 3;
  }
}

