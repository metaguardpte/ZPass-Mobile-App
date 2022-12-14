class Dates {

  static Map<int, String> intTOEngMapper = {
    1: "JANUARY",
    2: "FEBRUARY",
    3: "MARCH",
    4: "APRIL",
    5: "MAY",
    6: "JUNE",
    7: "JULY",
    8: "AUGUST",
    9: "SEPTEMBER",
    10: "OCTOBER",
    11: "NOVEMBER",
    12: "DECEMBER"
  };

  static String mapIntToEngName(int month) {
    var name =intTOEngMapper[month];
    if (name == null) {
      return "Unknown";
    }
    return name;
  }
}