import 'package:flutter/material.dart';
import 'package:zpass/res/zpass_icons.dart';

enum VaultItemType {
  login,
  note,
  credit,
  identity,
  metaMaskRawData,
  metaMaskMnemonicPhrase,
  addresses,
  tagAddress,
}

extension VaultItemTypeExt on VaultItemType {
  IconData get defaultFav {
    switch (this) {
      case VaultItemType.login: return ZPassIcons.favKey;
      case VaultItemType.note: return ZPassIcons.favNotes;
      case VaultItemType.credit: return ZPassIcons.favCard;
      case VaultItemType.identity: return ZPassIcons.favIdentity;
      default: return Icons.info_outline;
    }
  }
}