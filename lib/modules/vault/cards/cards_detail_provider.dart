import 'dart:convert';

import 'package:zpass/modules/home/model/vault_item_entity.dart';
import 'package:zpass/modules/home/provider/home_provider.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';
import 'package:zpass/modules/vault/model/vault_item_cards_content.dart';
import 'package:zpass/modules/vault/vault_item_provider.dart';
import 'package:zpass/plugin_bridge/crypto/crypto_manager.dart';
import 'package:zpass/util/log_utils.dart';

class CardsDetailProvider extends BaseVaultProvider {
  CardsDetailProvider() : super(HomeProvider().repoDB);

  VaultItemCardsContent? _content;
  VaultItemCardsContent? get content => _content;
  set content(VaultItemCardsContent? value) {
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
  Future analyticsData(VaultItemEntity? data) async {
    hasChange = false;
    if (data == null) return null;
    entity = data;
    tags = data.tags ?? [];
    Map<String, dynamic> detail = data.detail ?? {};
    if (detail.isEmpty) return null;
    editing = false;
    loading = true;
    try {
      final decryptStr = await CryptoManager().decryptText(text: detail["content"])
          .catchError((error) {
        Log.e("content decrypt error:${error.toString()}");
      });
      content = VaultItemCardsContent.fromJson(jsonDecode(decryptStr));
    } catch (e) {
      Log.e("content decrypt catch:${e.toString()}");
    }
    loading = false;
    return null;
  }

  Future<bool> update(
      {required String title,
        required String number,
        String? holder,
        String? expiry,
        String? cvv,
        String? zipCode,
        String? pin,
        String? note,
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
        type: VaultItemType.credit.index);
    // whether create new content or not
    content ??= VaultItemCardsContent();
    // update content
    content?.title = title;
    content?.number = number;
    content?.expiry = expiry;
    content?.holder = holder;
    content?.cvv = cvv;
    content?.zipOrPostalCode = zipCode;
    content?.pin = pin;
    content?.note = note;

    String? encryptedContent;
    await CryptoManager()
        .encryptText(text: jsonEncode(content!.toJson()))
        .then((value) => encryptedContent = value)
        .catchError((e) {
      Log.e("encrypt login detail content failed: $e", tag: "CardsDetailProvider");
    });
    if (encryptedContent == null) {
      return Future.error("vault entity detail's content encrypt failed");
    }
    // update entity
    entity!.tags = tags;
    entity!.name = title;
    entity!.description = number;
    entity!.detail = {"cardType": "uatp", "content": encryptedContent};
    //TODO update tags
    return db.update(entity!);
  }
}