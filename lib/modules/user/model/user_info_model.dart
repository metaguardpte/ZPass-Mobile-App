import 'package:json_annotation/json_annotation.dart';
import 'package:zpass/modules/user/model/user_crypto_key_model.dart';
import 'package:zpass/modules/user/model/user_type.dart';

part 'user_info_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserInfoModel {
  @JsonKey(name: "id")
  int userId;
  int userType;
  String? email;
  String? secretKey;
  String? avatar;
  String? userName;
  String? timezone;
  UserCryptoKeyModel? userCryptoKey;

  UserInfoModel({required this.userId, required this.userType});

  factory UserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);

  String get type {
    final index = userType - 1;
    if (index >= 0 && index < UserType.values.length) {
      return UserType.values[index].desc;
    } else {
      return "Unknown";
    }
  }
}
