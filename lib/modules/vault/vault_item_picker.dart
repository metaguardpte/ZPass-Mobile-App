import 'package:flutter/material.dart';
import 'package:zpass/modules/home/provider/vault_item_type.dart';
import 'package:zpass/modules/vault/vault_routers.dart';
import 'package:zpass/routers/fluro_navigator.dart';
import 'package:zpass/util/log_utils.dart';
import 'package:zpass/widgets/dialog/zpass_picker_dialog.dart';

class VaultItemPicker extends ZPassPickerDialog<VaultItemType> {
  VaultItemPicker(
      {required super.data, required super.onItemSelected, super.title})
      : super(name: "VaultItemPicker");

  @override
  Widget renderItem(BuildContext context, VaultItemType item, int index) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color.fromRGBO(235, 235, 235, 0.7),
            width: 0.5,
          ),
        ),
      ),
      height: 53,
      child: Text(
        item.desc,
        style: const TextStyle(color: Color(0xFF16181A), fontSize: 18),
      ),
    );
  }
}

void pickVaultType(BuildContext context) {
  itemSelected(type, index) {
    Log.d("pick vault item type: $type");
    switch (type) {
      case VaultItemType.login:
        NavigatorUtils.push(context, RoutersVault.vaultDetailLogin);
        break;
      case VaultItemType.credit:
        NavigatorUtils.push(context, RoutersVault.vaultDetailCards);
        break;
    }
  }

  VaultItemPicker(
          data: VaultItemType.values.sublist(0, 4),
          onItemSelected: itemSelected,
          title: "Items")
      .show(context);
}
