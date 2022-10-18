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
      description: json['description'] as String,
      detail: json['detail'] as String,
      type: $enumDecode(_$VaultItemTypeEnumMap, json['type']),
      star: json['star'] as bool,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      useTime: json['useTime'] as int,
    )..restoreTime = json['restoreTime'] as int?;

Map<String, dynamic> _$VaultItemEntityToJson(VaultItemEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'updateTime': instance.updateTime,
      'createTime': instance.createTime,
      'isDeleted': instance.isDeleted,
      'restoreTime': instance.restoreTime,
      'name': instance.name,
      'description': instance.description,
      'detail': instance.detail,
      'type': _$VaultItemTypeEnumMap[instance.type]!,
      'star': instance.star,
      'tags': instance.tags,
      'useTime': instance.useTime,
    };

const _$VaultItemTypeEnumMap = {
  VaultItemType.login: 'login',
  VaultItemType.note: 'note',
  VaultItemType.credit: 'credit',
  VaultItemType.identity: 'identity',
  VaultItemType.metaMaskRawData: 'metaMaskRawData',
  VaultItemType.metaMaskMnemonicPhrase: 'metaMaskMnemonicPhrase',
  VaultItemType.addresses: 'addresses',
  VaultItemType.tagAddress: 'tagAddress',
};
