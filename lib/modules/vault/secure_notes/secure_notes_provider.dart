import 'dart:convert';

import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/home/model/vault_item_login_detail.dart';
import 'package:zpass/modules/home/provider/home_provider.dart';
import 'package:zpass/modules/vault/model/vault_item_login_content.dart';
import 'package:zpass/modules/vault/vault_item_provider.dart';
import 'package:zpass/plugin_bridge/crypto/crypto_manager.dart';
import 'package:zpass/util/log_utils.dart';

class SecureNotesProvider extends BaseVaultProvider {
  static const String _tag = "SecureNotesProvider";

  SecureNotesProvider(): super(HomeProvider().repoDB);

  String? get targetUrl {
    if (entity == null) return null;
    final detail = VaultItemLoginDetail.fromJson(entity!.detail);
    return detail.loginUri;
  }

  VaultItemLoginContent? _content;
  VaultItemLoginContent? get content => _content;
  set content(VaultItemLoginContent? value) {
    _content = value;
    notifyListeners();
  }

  @override
  Future<dynamic> analyticsData(VaultItemEntity? data) async {
    if (data == null) return null;
    entity = data;
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
      content = VaultItemLoginContent.fromJson(jsonDecode(decryptContent));
    } catch (e) {
      Log.e("exception occur: $e", tag: _tag);
    }
    loading = false;
    return null;
  }
}