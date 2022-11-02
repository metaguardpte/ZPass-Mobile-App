import 'package:json_annotation/json_annotation.dart';
import 'package:zpass/modules/user/model/user_crypto_key_model.dart';
import 'package:zpass/modules/user/model/user_type.dart';

part 'user_info_model.g.dart';

@JsonSerializable()
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
    if (userType >= 0 && userType < UserType.values.length) {
      return UserType.values[userType].desc;
    } else {
      return "Unknown";
    }
  }
}
