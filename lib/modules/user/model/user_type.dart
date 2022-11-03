import 'package:zpass/generated/l10n.dart';

enum UserType {
  pilot(name: "Pilot", value: 1);

  final String name;
  final int value;
  const UserType({required this.name, required this.value});
}

extension UserTypeExt on UserType {
  String get desc {
    switch (this) {
      case UserType.pilot:
        return S.current.planTypePilot;
      default:
        return name;
    }
  }
}

extension UserTypeByValue on Iterable<UserType> {
  UserType byValue(int value) {
    for (var item in this) {
      if (item.value == value) return item;
    }
    throw ArgumentError.value(value, "value", "No enum with that value");
  }
}