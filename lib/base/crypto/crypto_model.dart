import 'package:json_annotation/json_annotation.dart';

part 'crypto_model.g.dart';

@JsonSerializable()
class CryptoModel {
  final int? code;
  final String? msg;
  final dynamic data;

  CryptoModel({this.code, this.msg, this.data});

  factory CryptoModel.fromJson(Map<String, dynamic> json) =>
      _$CryptoModelFromJson(json);

  Map<String, dynamic> toJson() => _$CryptoModelToJson(this);

  bool isSuccess() {
    return code == 0;
  }
}