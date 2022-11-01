// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_history_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PasswordHistoryEntity _$PasswordHistoryEntityFromJson(
        Map<String, dynamic> json) =>
    PasswordHistoryEntity(
      id: json['id'] as String,
      updateTime: json['updateTime'] as int,
      createTime: json['createTime'] as int,
      isDeleted: json['isDeleted'] as bool,
      password: json['password'] as String,
      source: json['source'] as int?,
      description: json['description'],
    )..restoreTime = json['restoreTime'] as int?;

Map<String, dynamic> _$PasswordHistoryEntityToJson(
        PasswordHistoryEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'updateTime': instance.updateTime,
      'createTime': instance.createTime,
      'isDeleted': instance.isDeleted,
      'restoreTime': instance.restoreTime,
      'password': instance.password,
      'source': instance.source,
      'description': instance.description,
    };
