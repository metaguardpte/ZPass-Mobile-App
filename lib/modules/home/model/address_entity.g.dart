// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressEntity _$AddressEntityFromJson(Map<String, dynamic> json) =>
    AddressEntity(
      id: json['id'] as String,
      updateTime: json['updateTime'] as int,
      createTime: json['createTime'] as int,
      isDeleted: json['isDeleted'] as bool,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    )..restoreTime = json['restoreTime'] as int?;

Map<String, dynamic> _$AddressEntityToJson(AddressEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'updateTime': instance.updateTime,
      'createTime': instance.createTime,
      'isDeleted': instance.isDeleted,
      'restoreTime': instance.restoreTime,
      'tags': instance.tags,
    };
