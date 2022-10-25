import 'package:json_annotation/json_annotation.dart';
import 'package:zpass/plugin_bridge/leveldb/record_entity.dart';
part 'token_multi_send_entity.g.dart';

@JsonSerializable()
class TokenMultiSendEntity extends RecordEntity {
  String status;
  dynamic token;
  String price;
  String sender;
  dynamic network;
  List<dynamic>? tx;

  TokenMultiSendEntity(
      {required super.id,
      required super.updateTime,
      required super.createTime,
      required super.isDeleted,
      required this.status,
      required this.token,
      required this.price,
      required this.sender,
      required this.network,
      required this.tx});

  factory TokenMultiSendEntity.fromJson(Map<String, dynamic> json) =>
      _$TokenMultiSendEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$TokenMultiSendEntityToJson(this);
}
