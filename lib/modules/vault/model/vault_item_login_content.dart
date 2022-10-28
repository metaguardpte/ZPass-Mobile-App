import 'package:json_annotation/json_annotation.dart';

part 'vault_item_login_content.g.dart';

@JsonSerializable()
class VaultItemLoginContent {
  String loginUser;
  String loginPassword;
  String? oneTimePassword;
  String? note;
  String? passwordUpdateTime;

  VaultItemLoginContent(
      {required this.loginUser,
      required this.loginPassword,
      this.oneTimePassword,
      this.note,
      this.passwordUpdateTime});

  factory VaultItemLoginContent.fromJson(Map<String, dynamic> json) =>
      _$VaultItemLoginContentFromJson(json);

  Map<String, dynamic> toJson() => _$VaultItemLoginContentToJson(this);
}
