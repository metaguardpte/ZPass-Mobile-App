// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_setting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSettingModel _$UserSettingModelFromJson(Map<String, dynamic> json) =>
    UserSettingModel(
      backupAndSync: json['backupAndSync'] as bool?,
      language: json['language'] as String?,
      syncProvider: json['syncProvider'] as String?,
    )
      ..backupDate = json['backupDate'] as String?
      ..syncDate = json['syncDate'] as String?
      ..syncAccount = json['syncAccount'] as String?;

Map<String, dynamic> _$UserSettingModelToJson(UserSettingModel instance) =>
    <String, dynamic>{
      'backupAndSync': instance.backupAndSync,
      'syncProvider': instance.syncProvider,
      'language': instance.language,
      'backupDate': instance.backupDate,
      'syncDate': instance.syncDate,
      'syncAccount': instance.syncAccount,
    };
