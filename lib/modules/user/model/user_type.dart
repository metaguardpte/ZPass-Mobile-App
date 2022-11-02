import 'package:zpass/generated/l10n.dart';

enum UserType {
  pilot(name: "Pilot");

  final String name;
  const UserType({required this.name});
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