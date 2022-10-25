import 'package:json_annotation/json_annotation.dart';
import 'package:zpass/plugin_bridge/leveldb/record_entity.dart';
part 'password_history_entity.g.dart';

@JsonSerializable()
class PasswordHistoryEntity extends RecordEntity {
  String password;
  String? source;
  dynamic description;

  PasswordHistoryEntity(
      {required super.id,
      required super.updateTime,
      required super.createTime,
      required super.isDeleted,
      required this.password,
      required this.source,
      required this.description});

  factory PasswordHistoryEntity.fromJson(Map<String, dynamic> json) =>
      _$PasswordHistoryEntityFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$PasswordHistoryEntityToJson(this);
}
