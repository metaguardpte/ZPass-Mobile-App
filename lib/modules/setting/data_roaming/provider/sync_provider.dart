import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/widgets/load_image.dart';

enum SyncProviderType {
  IPFS,
  googleDrive,
  dropBox,
  iCloud,
}

extension SyncProviderTypeExt on SyncProviderType {
  Widget get icon {
    switch (this) {
      case SyncProviderType.IPFS: return const LoadAssetImage('setting/ipfs',width: 18,height: 18,);
      case SyncProviderType.googleDrive: return const LoadAssetImage('setting/google_drive',width: 18,height: 18);
      case SyncProviderType.dropBox: return const LoadAssetImage('setting/dropbox',width: 18,height: 18);
      case SyncProviderType.iCloud: return const LoadAssetImage('setting/icloud',width: 18,height: 18);
      default: return Container();
    }
  }

  String get desc {
    switch (this) {
      case SyncProviderType.IPFS: return S.current.IPFS;
      case SyncProviderType.googleDrive: return S.current.googleDrive;
      case SyncProviderType.dropBox: return S.current.dropBox;
      case SyncProviderType.iCloud: return S.current.iCloud;
      default: return '';
    }
  }
}