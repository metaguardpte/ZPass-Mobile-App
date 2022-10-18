// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crypto_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CryptoModel _$CryptoModelFromJson(Map<String, dynamic> json) => CryptoModel(
      code: json['code'] as int?,
      msg: json['msg'] as String?,
      data: json['data'],
    );

Map<String, dynamic> _$CryptoModelToJson(CryptoModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'data': instance.data,
    };
