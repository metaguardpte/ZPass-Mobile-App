// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault_item_login_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VaultItemLoginContent _$VaultItemLoginContentFromJson(
        Map<String, dynamic> json) =>
    VaultItemLoginContent(
      loginUser: json['loginUser'] as String,
      loginPassword: json['loginPassword'] as String,
      oneTimePassword: json['oneTimePassword'] as String?,
      note: json['note'] as String?,
      passwordUpdateTime: json['passwordUpdateTime'] as String?,
    );

Map<String, dynamic> _$VaultItemLoginContentToJson(
        VaultItemLoginContent instance) =>
    <String, dynamic>{
      'loginUser': instance.loginUser,
      'loginPassword': instance.loginPassword,
      'oneTimePassword': instance.oneTimePassword,
      'note': instance.note,
      'passwordUpdateTime': instance.passwordUpdateTime,
    };
