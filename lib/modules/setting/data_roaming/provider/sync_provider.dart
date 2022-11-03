import 'package:flutter/material.dart';
import 'package:zpass/generated/l10n.dart';
import 'package:zpass/modules/sync/file_transfer/base_file_transfer.dart';
import 'package:zpass/modules/sync/file_transfer/google_drive_file_transfer.dart';
import 'package:zpass/res/zpass_icons.dart';
import 'package:zpass/widgets/load_image.dart';

enum SyncProviderType {
  googleDrive,
  IPFS,
  dropBox,
  iCloud,
}

extension SyncProviderTypeExt on SyncProviderType {
  BaseFileTransferManager _getFileTransferManager() {
    return GoogleDriveFileTransferManager();
  }

  Widget get icon {
    switch (this) {
      case SyncProviderType.googleDrive:
        return const LoadAssetImage('setting/google_drive',
            width: 18, height: 18);
      case SyncProviderType.IPFS:
        return const LoadAssetImage(
          'setting/ipfs',
          width: 18,
          height: 18,
        );
      case SyncProviderType.dropBox:
        return const LoadAssetImage('setting/dropbox', width: 18, height: 18);
      case SyncProviderType.iCloud:
        return const LoadAssetImage('setting/icloud', width: 18, height: 18);
      default:
        return Container();
    }
  }

  Future<String?> get getAccount {
    //
    switch (this) {
      case SyncProviderType.googleDrive:
        return _getFileTransferManager().getStorageAccount();
      default:
        return Future.value(null);
    }
  }

  String get desc {
    switch (this) {
      case SyncProviderType.IPFS: return S.current.IPFS;
      case SyncProviderType.googleDrive:
        return S.current.googleDrive;
      case SyncProviderType.dropBox: return S.current.dropBox;
      case SyncProviderType.iCloud: return S.current.iCloud;
      default:
        return '';
    }
  }
}
