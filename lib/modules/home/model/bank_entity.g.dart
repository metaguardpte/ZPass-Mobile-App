// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bank_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BankEntity _$BankEntityFromJson(Map<String, dynamic> json) => BankEntity(
      id: json['id'] as int?,
      bankName: json['bankName'] as String?,
      firstLetter: json['firstLetter'] as String?,
    );

Map<String, dynamic> _$BankEntityToJson(BankEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'bankName': instance.bankName,
      'firstLetter': instance.firstLetter,
    };
