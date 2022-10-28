import 'package:json_annotation/json_annotation.dart';
import 'package:zpass/plugin_bridge/leveldb/record_entity.dart';
part 'token_info_entity.g.dart';

@JsonSerializable()
class TokenInfoEntity extends RecordEntity {
  String name;
  String symbol;
  String divisor;
  dynamic network;

  TokenInfoEntity(
      {required super.id,
      required super.updateTime,
      required super.createTime,
      required super.isDeleted,
      required this.name,
      required this.symbol,
      required this.divisor,
      required this.network});

  factory TokenInfoEntity.fromJson(Map<String, dynamic> json) =>
      _$TokenInfoEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TokenInfoEntityToJson(this);
}
