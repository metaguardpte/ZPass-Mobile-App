import 'dart:convert';

import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/home/model/vault_item_login_detail.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';
import 'package:zpass/modules/vault/vault_detail_helper.dart';
import 'package:zpass/plugin_bridge/crypto/crypto_manager.dart';
import 'package:zpass/util/log_utils.dart';

class VaultItemWrapper {
  VaultItemEntity raw;

  String groupName;

  VaultItemWrapper({required this.raw, required this.groupName});

  String get title => raw.name;
  String get subtitle {
    final type = VaultItemType.values[raw.type];
    switch (type) {
      case VaultItemType.login:
        // final detail = VaultItemLoginDetail.fromJson(raw.detail);
        // return detail.loginUri ?? "";
        return jsonDecode(decryptContent)["loginUser"];
      default:
        return raw.description ?? "";
    }
  }

  String? get icon {
    final type = VaultItemType.values[raw.type];
    switch (type) {
      case VaultItemType.login:
        return parseVaultLoginIconUrl(raw);
      default:
        return null;
    }
  }

  dynamic decryptContent;
  Future<void> decrypt() async {
    final type = VaultItemType.values[raw.type];
    switch (type) {
      case VaultItemType.login:
        final detail = VaultItemLoginDetail.fromJson(raw.detail);
        Log.d("encrypted content: ${detail.content}");
        decryptContent = await CryptoManager()
            .decryptText(text: detail.content)
            .catchError((e) {
          Log.e("decrypt login detail content failed: $e");
        });
        Log.d("decrypted content: $decryptContent");
        break;
      default:
        return Future.value();
    }
  }
}