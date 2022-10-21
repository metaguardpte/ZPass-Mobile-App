import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'record_entity.g.dart';

@JsonSerializable()
class RecordEntity {
  ///
  ///当前Entity的id生成和格式是：uuid version 4，去掉横杠并小写
  // 比如：02c7f26cde7947689548da6bf07eca19
  ///
  String id;
  int updateTime;
  int createTime;
  bool isDeleted;
  int? restoreTime;

  RecordEntity(
      {required this.id,
      required this.updateTime,
      required this.createTime,
      required this.isDeleted,
      this.restoreTime});

  factory RecordEntity.fromJson(Map<String, dynamic> json) =>
      _$RecordEntityFromJson(json);

  Map<String, dynamic> toJson() => _$RecordEntityToJson(this);

  String getEntityKey() {
    return id;
  }

  String getEntityValue() {
    return jsonEncode(this);
  }
}
