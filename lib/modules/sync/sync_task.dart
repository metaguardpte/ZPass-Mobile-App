
import 'package:zpass/modules/sync/db_sync/db_sync.dart';
import 'package:zpass/modules/sync/file_transfer/base_file_transfer.dart';
import 'package:zpass/modules/sync/file_transfer/google_drive_file_transfer.dart';
import 'package:zpass/plugin_bridge/leveldb/zpass_db.dart';

class SyncTask {

  void run() {
    var remoteFilePath = _getRemoteFilePath();
    BaseFileTransferManager fileTransferManager = _getFileTransferManager();
    var unzipDBFolder = fileTransferManager.download(remoteFilePath);

    DBSyncUnit.sync(unzipDBFolder);

    var localDBPath = ZPassDB().getDBPath();
    var zipFileDest = fileTransferManager.copyAndZip(localDBPath);
    fileTransferManager.upload(zipFileDest, remoteFilePath);
  }

  BaseFileTransferManager _getFileTransferManager() {
    return GoogleDriveFileTransferManager();
  }

  String _getRemoteFilePath() {
    return "";
  }
}