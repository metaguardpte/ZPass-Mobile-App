import 'package:json_annotation/json_annotation.dart';
import 'package:zpass/plugin_bridge/leveldb/record_entity.dart';
part 'address_entity.g.dart';

@JsonSerializable()
class AddressEntity extends RecordEntity {
  List<String>? tags;

  AddressEntity(
      {required super.id,
      required super.updateTime,
      required super.createTime,
      required super.isDeleted,
      required this.tags});

  factory AddressEntity.fromJson(Map<String, dynamic> json) =>
      _$AddressEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AddressEntityToJson(this);
}
