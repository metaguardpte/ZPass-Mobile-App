import 'package:json_annotation/json_annotation.dart';

part 'user_crypto_key_model.g.dart';

@JsonSerializable()
class UserCryptoKeyModel {
  String? token;
  String? identifierProof;
  String? personalDataKey;
  String? enterpriseDataKey;
  String? masterKeyHash;
  String? masterKeyExported;

  UserCryptoKeyModel(
      {this.token,
      this.identifierProof,
      this.enterpriseDataKey,
      this.masterKeyExported,
      this.masterKeyHash,
      this.personalDataKey});

  factory UserCryptoKeyModel.fromJson(Map<String, dynamic> json) =>
      _$UserCryptoKeyModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$UserCryptoKeyModelToJson(this);
}
