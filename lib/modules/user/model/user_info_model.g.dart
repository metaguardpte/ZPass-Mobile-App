// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoModel _$UserInfoModelFromJson(Map<String, dynamic> json) =>
    UserInfoModel(
      userId: json['id'] as int,
      userType: json['userType'] as int,
    )
      ..email = json['email'] as String?
      ..secretKey = json['secretKey'] as String?
      ..avatar = json['avatar'] as String?
      ..userName = json['userName'] as String?
      ..timezone = json['timezone'] as String?
      ..userCryptoKey = json['userCryptoKey'] == null
          ? null
          : UserCryptoKeyModel.fromJson(
              json['userCryptoKey'] as Map<String, dynamic>);

Map<String, dynamic> _$UserInfoModelToJson(UserInfoModel instance) =>
    <String, dynamic>{
      'id': instance.userId,
      'userType': instance.userType,
      'email': instance.email,
      'secretKey': instance.secretKey,
      'avatar': instance.avatar,
      'userName': instance.userName,
      'timezone': instance.timezone,
      'userCryptoKey': instance.userCryptoKey?.toJson(),
    };
