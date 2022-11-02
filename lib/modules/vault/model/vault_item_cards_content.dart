import 'package:json_annotation/json_annotation.dart';

part 'vault_item_cards_content.g.dart';

@JsonSerializable()
class VaultItemCardsContent {
  String? title;
  String? holder;
  String? number;
  String? expiry;
  String? cvv;
  String? zipOrPostalCode;
  String? pin;
  String? note;

  VaultItemCardsContent({
    this.title,
    this.holder,
    this.number,
    this.expiry,
    this.cvv,
    this.zipOrPostalCode,
    this.pin,
    this.note,
  });

  factory VaultItemCardsContent.fromJson(Map<String, dynamic> json) =>
      _$VaultItemCardsContentFromJson(json);

  Map<String, dynamic> toJson() => _$VaultItemCardsContentToJson(this);
}