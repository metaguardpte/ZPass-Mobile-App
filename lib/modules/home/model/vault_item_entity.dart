import 'package:json_annotation/json_annotation.dart';
import 'package:zpass/plugin_bridge/leveldb/record_entity.dart';
part 'vault_item_entity.g.dart';

@JsonSerializable(explicitToJson: true)
class VaultItemEntity extends RecordEntity {
  String name;
  String? description;
  dynamic detail;
  int type;
  bool? star;
  List<String>? tags;
  int? useTime;

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

  @override
  String getEntityKey() {
    return "!vaultItem!$id";
  }
}
