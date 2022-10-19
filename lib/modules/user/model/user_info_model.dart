import 'package:json_annotation/json_annotation.dart';
import 'package:zpass/modules/user/model/user_crypto_key_model.dart';

part 'user_info_model.g.dart';

@JsonSerializable()
class UserInfoModel {
  String? email;
  String? secretKey;
  String? icon;
  String? name;
  UserCryptoKeyModel? userCryptoKey;

  UserInfoModel({this.email, this.icon, this.name, this.secretKey,this.userCryptoKey});

  factory UserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfoModelFromJson(json);
  setValue(UserInfoModel value){
    email = value.email;
    secretKey = value.secretKey;
    icon = value.icon;
    name = value.name;
  }
  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);
}
