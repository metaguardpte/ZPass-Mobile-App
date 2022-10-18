import 'package:json_annotation/json_annotation.dart';
import 'package:zpass/modules/home/model/record_entity.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';

part 'vault_item_entity.g.dart';

@JsonSerializable()
class VaultItemEntity extends RecordEntity {
  String name;
  String description;
  String detail;
  VaultItemType type;
  bool star;
  List<String> tags;
  int useTime;

  VaultItemEntity(
      {required super.id,
      required super.updateTime,
      required super.createTime,
      required super.isDeleted,
      required this.name,
      required this.description,
      required this.detail,
      required this.type,
      required this.star,
      required this.tags,
      required this.useTime});

  factory VaultItemEntity.fromJson(Map<String, dynamic> json) =>
      _$VaultItemEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$VaultItemEntityToJson(this);
}
