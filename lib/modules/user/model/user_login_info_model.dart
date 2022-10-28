import 'package:json_annotation/json_annotation.dart';

part 'user_login_info_model.g.dart';

@JsonSerializable()
class UserLoginInfoModel {
  bool? biometrics;
  int? requirePasswordDay;
  DateTime? lastLoginTime;
  final String email;

  UserLoginInfoModel({
    this.biometrics = false,
    this.requirePasswordDay = 14,
    this.lastLoginTime,
    required this.email,
  });

  factory UserLoginInfoModel.fromJson(Map<String, dynamic> json) => _$UserLoginInfoModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserLoginInfoModelToJson(this);

}