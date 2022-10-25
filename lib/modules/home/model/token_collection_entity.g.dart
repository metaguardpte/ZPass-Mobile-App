// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_collection_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenCollectionEntity _$TokenCollectionEntityFromJson(
        Map<String, dynamic> json) =>
    TokenCollectionEntity(
      id: json['id'] as String,
      updateTime: json['updateTime'] as int,
      createTime: json['createTime'] as int,
      isDeleted: json['isDeleted'] as bool,
      status: json['status'] as String,
      token: json['token'],
      price: json['price'] as String,
      recipient: json['recipient'] as String,
      network: json['network'],
      tx: json['tx'] as List<dynamic>?,
    )..restoreTime = json['restoreTime'] as int?;

Map<String, dynamic> _$TokenCollectionEntityToJson(
        TokenCollectionEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'updateTime': instance.updateTime,
      'createTime': instance.createTime,
      'isDeleted': instance.isDeleted,
      'restoreTime': instance.restoreTime,
      'status': instance.status,
      'token': instance.token,
      'price': instance.price,
      'recipient': instance.recipient,
      'network': instance.network,
      'tx': instance.tx,
    };
