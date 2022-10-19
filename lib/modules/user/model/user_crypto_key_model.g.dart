// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_crypto_key_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCryptoKeyModel _$UserCryptoKeyModelFromJson(Map<String, dynamic> json) =>
    UserCryptoKeyModel(
      token: json['token'] as String?,
      identifierProof: json['identifierProof'] as String?,
      enterpriseDataKey: json['enterpriseDataKey'] as String?,
      masterKeyExported: json['masterKeyExported'] as String?,
      masterKeyHash: json['masterKeyHash'] as String?,
      personalDataKey: json['personalDataKey'] as String?,
    );

Map<String, dynamic> _$UserCryptoKeyModelToJson(UserCryptoKeyModel instance) =>
    <String, dynamic>{
      'token': instance.token,
      'identifierProof': instance.identifierProof,
      'personalDataKey': instance.personalDataKey,
      'enterpriseDataKey': instance.enterpriseDataKey,
      'masterKeyHash': instance.masterKeyHash,
      'masterKeyExported': instance.masterKeyExported,
    };
