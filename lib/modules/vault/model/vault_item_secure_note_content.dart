import 'package:json_annotation/json_annotation.dart';

part 'vault_item_secure_note_content.g.dart';

@JsonSerializable()
class VaultItemSecureNoteContent {
  String title;
  String note;

  VaultItemSecureNoteContent(
      {required this.title,
        required this.note,
        });

  factory VaultItemSecureNoteContent.fromJson(Map<String, dynamic> json) =>
      _$VaultItemSecureNoteContentFromJson(json);

  Map<String, dynamic> toJson() => _$VaultItemSecureNoteContentToJson(this);
}
