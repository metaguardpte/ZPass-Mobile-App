// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vault_item_cards_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VaultItemCardsContent _$VaultItemCardsContentFromJson(
        Map<String, dynamic> json) =>
    VaultItemCardsContent(
      title: json['title'] as String?,
      holder: json['holder'] as String?,
      number: json['number'] as String?,
      expiry: json['expiry'] as String?,
      cvv: json['cvv'] as String?,
      zipOrPostalCode: json['zipOrPostalCode'] as String?,
      pin: json['pin'] as String?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$VaultItemCardsContentToJson(
        VaultItemCardsContent instance) =>
    <String, dynamic>{
      'title': instance.title,
      'holder': instance.holder,
      'number': instance.number,
      'expiry': instance.expiry,
      'cvv': instance.cvv,
      'zipOrPostalCode': instance.zipOrPostalCode,
      'pin': instance.pin,
      'note': instance.note,
    };
