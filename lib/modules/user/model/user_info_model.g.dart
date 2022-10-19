// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfoModel _$UserInfoModelFromJson(Map<String, dynamic> json) =>
    UserInfoModel(
      email: json['email'] as String?,
      icon: json['icon'] as String?,
      name: json['name'] as String?,
      secretKey: json['secretKey'] as String?,
      userCryptoKey: json['userCryptoKey'] == null
          ? null
          : UserCryptoKeyModel.fromJson(
              json['userCryptoKey'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserInfoModelToJson(UserInfoModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'secretKey': instance.secretKey,
      'icon': instance.icon,
      'name': instance.name,
      'userCryptoKey': instance.userCryptoKey,
    };
