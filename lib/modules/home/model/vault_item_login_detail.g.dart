// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault_item_login_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VaultItemLoginDetail _$VaultItemLoginDetailFromJson(
        Map<String, dynamic> json) =>
    VaultItemLoginDetail()
      ..content = json['content']
      ..loginUri = json['loginUri'] as String?;

Map<String, dynamic> _$VaultItemLoginDetailToJson(
        VaultItemLoginDetail instance) =>
    <String, dynamic>{
      'content': instance.content,
      'loginUri': instance.loginUri,
    };
