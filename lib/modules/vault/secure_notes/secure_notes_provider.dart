import 'dart:convert';

import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/home/model/vault_item_login_detail.dart';
import 'package:zpass/modules/home/provider/home_provider.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';
import 'package:zpass/modules/vault/model/vault_item_secure_note_content.dart';
import 'package:zpass/modules/vault/vault_item_provider.dart';
import 'package:zpass/plugin_bridge/crypto/crypto_manager.dart';
import 'package:zpass/util/log_utils.dart';

class SecureNotesProvider extends BaseVaultProvider {
  static const String _tag = "SecureNotesProvider";

  SecureNotesProvider(): super(HomeProvider().repoDB);


  VaultItemSecureNoteContent? _content;
  VaultItemSecureNoteContent? get content => _content;
  set content(VaultItemSecureNoteContent? value) {
    _content = value;
    notifyListeners();
  }

  List<String> _tags = [];
  List<String> get tags => _tags;
  set tags(List<String> value) {
    _tags = value;
    notifyListeners();
  }

  @override
  Future<dynamic> analyticsData(VaultItemEntity? data) async {
    hasChange = false;
    if (data == null) return null;
    entity = data;
    tags = data.tags ?? [];
    editing = false;
    loading = true;
    try {
      final detail = VaultItemLoginDetail.fromJson(data.detail);
      Log.d("encrypted content: ${detail.content}", tag: _tag);
      final decryptContent = await CryptoManager()
          .decryptText(text: detail.content)
          .catchError((e) {
        Log.e("decrypt login detail content failed: $e", tag: _tag);
      });
      Log.d("decrypted content: $decryptContent", tag: _tag);
      _content = VaultItemSecureNoteContent.fromJson(jsonDecode(decryptContent));
    } catch (e) {
      Log.e("exception occur: $e", tag: _tag);
    }
    loading = false;
    return null;
  }

  Future<bool> secureNodeUpdate(
      {required String title,
        required String note,
        }) async {
    // whether create new entity or not
    entity ??= VaultItemEntity(
        id: generateItemId(),
        createTime: DateTime.now().millisecondsSinceEpoch,
        updateTime: DateTime.now().millisecondsSinceEpoch,
        useTime: DateTime.now().millisecondsSinceEpoch,
        isDeleted: false,
        name: title,
        detail: null,
        type: VaultItemType.note.index);
    // whether create new content or not
    content ??= VaultItemSecureNoteContent(
        title: title, note: note);
    // update content
    content!.title = title;
    content!.note = note;

    String? encryptedContent;
    await CryptoManager()
        .encryptText(text: jsonEncode(content!.toJson()))
        .then((value) => encryptedContent = value)
        .catchError((e) {
      Log.e("encrypt login detail content failed: $e", tag: _tag);
    });
    if (encryptedContent == null) {
      return Future.error("vault entity detail's content encrypt failed");
    }
    // update entity
    entity!.name = title;
    entity!.tags = tags;
    entity!.updateTime = DateTime.now().millisecondsSinceEpoch;
    entity!.detail = {
      "content":encryptedContent
    };
    entity!.description = '';
    return db.update(entity!);
  }
}