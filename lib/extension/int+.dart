import 'package:intl/intl.dart';
import 'package:zpass/util/date_utils.dart';

const int justNow = 5 * 60;
const int hour = 60 * 60;
const int day = 24 * hour;
const int week = day * 7;
const int month = day * 30;
const int year = day * 365;

extension IntExt on int  {
  String formatDateTime({String format = dateFormat_YMD_HM}) {
    if (this < 1) {
      return "";
    }
    return DateFormat(format).format(DateTime.fromMillisecondsSinceEpoch(this));
  }

  String toThousandth() {
    var format = NumberFormat("#,##0");
    return format.format(this);
  }
}