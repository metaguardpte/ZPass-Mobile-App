// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_setting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSettingModel _$UserSettingModelFromJson(Map<String, dynamic> json) =>
    UserSettingModel(
      backupAndSync: json['backupAndSync'] as bool?,
      language: json['language'] as String?,
    );

Map<String, dynamic> _$UserSettingModelToJson(UserSettingModel instance) =>
    <String, dynamic>{
      'backupAndSync': instance.backupAndSync,
      'language': instance.language,
    };