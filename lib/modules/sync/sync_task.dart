
import 'package:zpass/modules/sync/db_sync/db_sync.dart';
import 'package:zpass/modules/sync/file_transfer/base_file_transfer.dart';
import 'package:zpass/modules/sync/file_transfer/google_drive_file_transfer.dart';
import 'package:zpass/plugin_bridge/leveldb/zpass_db.dart';

class SyncTask {

  void run() async {
    BaseFileTransferManager fileTransferManager = _getFileTransferManager();
    var unzipDBFolder = await fileTransferManager.download();

    DBSyncUnit.sync(unzipDBFolder);

    var localDBPath = ZPassDB().getDBPath();
    fileTransferManager.upload(localDBPath);
  }

  BaseFileTransferManager _getFileTransferManager() {
    return GoogleDriveFileTransferManager();
  }
}