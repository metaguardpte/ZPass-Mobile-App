import 'package:json_annotation/json_annotation.dart';
import 'package:zpass/plugin_bridge/leveldb/record_entity.dart';
part 'token_collection_entity.g.dart';

@JsonSerializable()
class TokenCollectionEntity extends RecordEntity {
  String status;
  dynamic token;
  String price;
  String recipient;
  dynamic network;
  List<dynamic>? tx;

  TokenCollectionEntity(
      {required super.id,
      required super.updateTime,
      required super.createTime,
      required super.isDeleted,
      required this.status,
      required this.token,
      required this.price,
      required this.recipient,
      required this.network,
      required this.tx});

  factory TokenCollectionEntity.fromJson(Map<String, dynamic> json) =>
      _$TokenCollectionEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TokenCollectionEntityToJson(this);
}
