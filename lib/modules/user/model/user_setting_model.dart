import 'package:json_annotation/json_annotation.dart';
import 'package:zpass/modules/setting/data_roaming/provider/sync_provider.dart';
import 'package:zpass/modules/user/model/user_crypto_key_model.dart';

part 'user_setting_model.g.dart';

@JsonSerializable()
class UserSettingModel {
  bool? backupAndSync;
  String? syncProvider;
  String? language;

  UserSettingModel({this.backupAndSync,this.language,this.syncProvider});

  factory UserSettingModel.fromJson(Map<String, dynamic> json) =>
      _$UserSettingModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserSettingModelToJson(this);
}
