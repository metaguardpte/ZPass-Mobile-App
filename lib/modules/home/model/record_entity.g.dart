// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordEntity _$RecordEntityFromJson(Map<String, dynamic> json) => RecordEntity(
      id: json['id'] as String,
      updateTime: json['updateTime'] as int,
      createTime: json['createTime'] as int,
      isDeleted: json['isDeleted'] as bool,
      restoreTime: json['restoreTime'] as int?,
    );

Map<String, dynamic> _$RecordEntityToJson(RecordEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'updateTime': instance.updateTime,
      'createTime': instance.createTime,
      'isDeleted': instance.isDeleted,
      'restoreTime': instance.restoreTime,
    };
