// ignore_for_file: constant_identifier_names

const dateFormat_WEEKDAY = "EEEE";
const dateFormat_YMD = "yyyy/MM/dd";
const dateFormat_Y_M_D = "yyyy-MM-dd";
const dateFormat_M_D = "MM-dd";
const dateFormat_YMD_HM = "yyyy/MM/dd HH:mm";
const dateFormat_MD_HM = "MM/dd HH:mm";

class DateUtils {
  static int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }
}