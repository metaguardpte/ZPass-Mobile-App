import 'package:json_annotation/json_annotation.dart';

part 'bank_entity.g.dart';

@JsonSerializable()
class BankEntity {

	BankEntity({this.id, this.bankName, this.firstLetter});

	factory BankEntity.fromJson(Map<String, dynamic> json) => _$BankEntityFromJson(json);

	Map<String, dynamic> toJson() => _$BankEntityToJson(this);

	int? id;
	String? bankName;
	String? firstLetter;
}
