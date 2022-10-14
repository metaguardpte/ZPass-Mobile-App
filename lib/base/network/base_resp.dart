import 'package:json_annotation/json_annotation.dart';

part 'base_resp.g.dart';

@JsonSerializable()
class BaseResp {
  int code;
  String? message;
  dynamic data;

  BaseResp({required this.code, required this.data, this.message});

  factory BaseResp.fromJson(Map<String, dynamic> json) => _$BaseRespFromJson(json);
  Map<String, dynamic> toJson() => _$BaseRespToJson(this);

  bool isHttpOK() {
    return code == 200;
  }

  bool hasError() {
    Map<String, dynamic>? dataMap = data as Map<String, dynamic>?;
    return dataMap!= null && dataMap.containsKey("error") && dataMap["error"] != null;
  }

  dynamic getPayload() {
    Map<String, dynamic>? dataMap = data as Map<String, dynamic>?;
    return dataMap?["payload"];
  }

  dynamic getError() {
    Map<String, dynamic>? dataMap = data as Map<String, dynamic>?;
    return dataMap?["error"];
  }
}