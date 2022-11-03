import 'package:json_annotation/json_annotation.dart';

part 'user_setting_model.g.dart';

@JsonSerializable()
class UserSettingModel {
  bool? backupAndSync;
  String? syncProvider;
  String? language;
  String? backupDate;
  String? syncDate;
  String? syncAccount;

  UserSettingModel({this.backupAndSync,this.language,this.syncProvider});

  factory UserSettingModel.fromJson(Map<String, dynamic> json) =>
      _$UserSettingModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserSettingModelToJson(this);
}
