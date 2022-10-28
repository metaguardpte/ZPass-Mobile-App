// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_info_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenInfoEntity _$TokenInfoEntityFromJson(Map<String, dynamic> json) =>
    TokenInfoEntity(
      id: json['id'] as String,
      updateTime: json['updateTime'] as int,
      createTime: json['createTime'] as int,
      isDeleted: json['isDeleted'] as bool,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      divisor: json['divisor'] as String,
      network: json['network'],
    )..restoreTime = json['restoreTime'] as int?;

Map<String, dynamic> _$TokenInfoEntityToJson(TokenInfoEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'updateTime': instance.updateTime,
      'createTime': instance.createTime,
      'isDeleted': instance.isDeleted,
      'restoreTime': instance.restoreTime,
      'name': instance.name,
      'symbol': instance.symbol,
      'divisor': instance.divisor,
      'network': instance.network,
    };
