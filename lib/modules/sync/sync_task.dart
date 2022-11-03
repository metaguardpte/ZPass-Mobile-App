import 'dart:async';

import 'package:zpass/modules/sync/db_sync/db_sync.dart';
import 'package:zpass/modules/sync/file_transfer/base_file_transfer.dart';
import 'package:zpass/modules/sync/file_transfer/google_drive_file_transfer.dart';
import 'package:zpass/plugin_bridge/leveldb/zpass_db.dart';
import 'package:zpass/util/log_utils.dart';

import '../user/user_provider.dart';

class SyncTask {
  static const period = Duration(minutes: 30);
  static Timer? timer;

  static void run() {
    timer ??= Timer.periodic(period, (Timer t) => _doRun());
  }

  static void cancel() {
    timer?.cancel();
  }

  static void _doRun() async {
    final userId = UserProvider().profile.data.userId;
    if (userId <= 0) {
      Log.d("Skip sync data due to empty userId");
      return;
    }
    String userIdInString = userId.toString();
    BaseFileTransferManager fileTransferManager = _getFileTransferManager();
    String transferType = fileTransferManager.getTransferType();

    try {
      var storageAccount = await fileTransferManager.getStorageAccount();
      var unzipDBFolder = await fileTransferManager.download(userIdInString);
      await DBSyncUnit.sync(unzipDBFolder);
      Log.d(
          "Success sync data from remote(type:$transferType, account:$storageAccount)"
          " for zpass user:$userId");
      fileTransferManager.deleteTempAssets(unzipDBFolder);

      var localDBPath = ZPassDB().getDBPath();
      await fileTransferManager.upload(localDBPath, userIdInString);
      Log.d(
          "Success upload data to remote(type:$transferType, account:$storageAccount)"
          " for zpass user:$userId");
    } catch (exception) {
      Log.e("Sync failed. type:$transferType, error:$exception");
    }
  }

  static BaseFileTransferManager _getFileTransferManager() {
    return GoogleDriveFileTransferManager();
  }
}
