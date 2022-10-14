// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_resp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResp _$BaseRespFromJson(Map<String, dynamic> json) => BaseResp(
      code: json['code'] as int,
      data: json['data'],
      message: json['message'] as String?,
    );

Map<String, dynamic> _$BaseRespToJson(BaseResp instance) => <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
