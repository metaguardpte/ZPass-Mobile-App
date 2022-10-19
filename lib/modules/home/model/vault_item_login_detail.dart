import 'package:json_annotation/json_annotation.dart';

part 'vault_item_login_detail.g.dart';

@JsonSerializable()
class VaultItemLoginDetail {
  dynamic content;
  String? loginUri;

  VaultItemLoginDetail();

  factory VaultItemLoginDetail.fromJson(Map<String, dynamic> json) =>
      _$VaultItemLoginDetailFromJson(json);

  Map<String, dynamic> toJson() => _$VaultItemLoginDetailToJson(this);
}