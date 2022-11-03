// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_login_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserLoginInfoModel _$UserLoginInfoModelFromJson(Map<String, dynamic> json) =>
    UserLoginInfoModel(
      biometrics: json['biometrics'] as bool? ?? false,
      requirePasswordDay: json['requirePasswordDay'] as int? ?? 7,
      lastLoginTime: json['lastLoginTime'] == null
          ? null
          : DateTime.parse(json['lastLoginTime'] as String),
      email: json['email'] as String,
    );

Map<String, dynamic> _$UserLoginInfoModelToJson(UserLoginInfoModel instance) =>
    <String, dynamic>{
      'biometrics': instance.biometrics,
      'requirePasswordDay': instance.requirePasswordDay,
      'lastLoginTime': instance.lastLoginTime?.toIso8601String(),
      'email': instance.email,
    };
