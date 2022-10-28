// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_multi_send_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenMultiSendEntity _$TokenMultiSendEntityFromJson(
        Map<String, dynamic> json) =>
    TokenMultiSendEntity(
      id: json['id'] as String,
      updateTime: json['updateTime'] as int,
      createTime: json['createTime'] as int,
      isDeleted: json['isDeleted'] as bool,
      status: json['status'] as String,
      token: json['token'],
      price: json['price'] as String,
      sender: json['sender'] as String,
      network: json['network'],
      tx: json['tx'] as List<dynamic>?,
    )..restoreTime = json['restoreTime'] as int?;

Map<String, dynamic> _$TokenMultiSendEntityToJson(
        TokenMultiSendEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'updateTime': instance.updateTime,
      'createTime': instance.createTime,
      'isDeleted': instance.isDeleted,
      'restoreTime': instance.restoreTime,
      'status': instance.status,
      'token': instance.token,
      'price': instance.price,
      'sender': instance.sender,
      'network': instance.network,
      'tx': instance.tx,
    };
