// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault_item_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VaultItemEntity _$VaultItemEntityFromJson(Map<String, dynamic> json) =>
    VaultItemEntity(
      id: json['id'] as String,
      updateTime: json['updateTime'] as int,
      createTime: json['createTime'] as int,
      isDeleted: json['isDeleted'] as bool,
      name: json['name'] as String,
      detail: json['detail'],
      type: json['type'] as int,
      description: json['description'] as String?,
      star: json['star'] as bool?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      useTime: json['useTime'] as int?,
    )
      ..restoreTime = json['restoreTime'] as int?
      ..title = json['title'] as String?
      ..note = json['note'] as String?;

Map<String, dynamic> _$VaultItemEntityToJson(VaultItemEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'updateTime': instance.updateTime,
      'createTime': instance.createTime,
      'isDeleted': instance.isDeleted,
      'restoreTime': instance.restoreTime,
      'name': instance.name,
      'description': instance.description,
      'title': instance.title,
      'note': instance.note,
      'detail': instance.detail,
      'type': instance.type,
      'star': instance.star,
      'tags': instance.tags,
      'useTime': instance.useTime,
    };
