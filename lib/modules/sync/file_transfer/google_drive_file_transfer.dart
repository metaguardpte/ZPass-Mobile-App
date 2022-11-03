import 'dart:async';
import 'dart:core';
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:path_provider/path_provider.dart';
import 'package:zpass/modules/setting/data_roaming/provider/sync_provider.dart';
import 'package:zpass/modules/sync/file_transfer/base_file_transfer.dart';
import "package:http/http.dart" as http;
import 'package:_discoveryapis_commons/_discoveryapis_commons.dart' as commons;
import 'package:zpass/util/log_utils.dart';

class GoogleDriveFileTransferManager extends BaseFileTransferManager {
  GoogleSignIn? _googleSignIn;
  GoogleSignInAccount? _account;
  drive.DriveApi? _driveApi;
  final _completer = Completer<String>();

  final _defaultDir = "zpass";
  final _defaultUserDir = "sync-";

  @override
  Future<String> doDownload(String userId) async {
    if (_account == null) {
      await _signinUser();
    }

    String? fileId = await _getDefaultFileId(_driveApi!, userId);
    Object result = await _driveApi!.files
        .get(fileId!, downloadOptions: commons.DownloadOptions.fullMedia);
    result as commons.Media;

    List<int> dataStore = [];
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String uniqueFile = "${getUniqueDir()}.7z";

    //folder name with only number is FORBIDDEN!
    String zipFile = '$tempPath${separator}sync-$userId$separator$uniqueFile';

    result.stream.listen((data) {
      dataStore.insertAll(dataStore.length, data);
    }, onDone: () async {
      File file = File(zipFile);
      file.createSync(recursive: true);
      file.writeAsBytesSync(dataStore, mode: FileMode.write, flush: true);
      Log.d("Success download google drive file to $zipFile");
      return _completer.complete(zipFile);
    }, onError: (error) {
      Log.e("download $fileId from google dirve failed:${error.toString()}");
    });

    return _completer.future;
  }

  @override
  Future doUpload(String source, String userId) async {
    if (_account == null) {
      await _signinUser();
    }

    File sourceFile = File(source);
    drive.File fileToUpload = drive.File();
    fileToUpload.name = defaultZipFileName;

    var zipFileId = await _getDefaultFileId(_driveApi!, userId);
    if (zipFileId == null) {
      String? defaultFolderId = await _getDefaultDirId(_driveApi!);
      String? userFolderId =
          await _getUserDirId(_driveApi!, defaultFolderId!, userId);

      fileToUpload.parents = [userFolderId!];

      await _driveApi?.files.create(
        fileToUpload,
        uploadMedia:
            drive.Media(sourceFile.openRead(), sourceFile.lengthSync()),
      );
    } else {
      var uploadMedia =
          commons.Media(sourceFile.openRead(), sourceFile.lengthSync());
      await _driveApi?.files
          .update(fileToUpload, zipFileId, uploadMedia: uploadMedia);
    }
    Log.d("Success upload db file:($zipFileId) to google drive");
  }

  @override
  Future<String?> getStorageAccount() async {
    if (_account == null) {
      await _signinUser();
    }

    String? displayName = _account?.displayName;
    if (displayName == null){
      return _account?.email;
    }
    return displayName;
  }

  @override
  String getTransferType() {
    return SyncProviderType.googleDrive.name;
  }

  Future _signinUser() async {
    _googleSignIn =
        signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
    _account = await _googleSignIn!.signIn();
    final authHeaders = await _account!.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    _driveApi = drive.DriveApi(authenticateClient);
  }

  Future<void> _signOutUser() async {
    try {
      await _googleSignIn!.disconnect();
      _account = null;
      _driveApi = null;
    } catch (error) {
      Log.e("google signout failed:$error");
    }
  }

  Future<String?> _getDefaultFileId(
      drive.DriveApi driveApi, String userId) async {
    final defaultFolderId = await _getDefaultDirId(driveApi);
    final userFolderId =
        await _getUserDirId(driveApi, defaultFolderId!, userId);

    drive.FileList fileList = await driveApi.files.list(
      spaces: 'drive',
      q: "'$userFolderId' in parents",
    );

    var myListFiltered =
        fileList.files!.where((e) => e.name == defaultZipFileName);
    if (myListFiltered.isEmpty) {
      return null;
    } else {
      return myListFiltered.first.id;
    }
  }

  Future<String?> _getUserDirId(
      drive.DriveApi driveApi, String defaultFileId, String userId) async {
    const mimeType = "application/vnd.google-apps.folder";
    var defaultUserFolderName = '$_defaultUserDir$userId';
    try {
      final found = await driveApi.files.list(
        q: "mimeType = '$mimeType' and name = '$defaultUserFolderName'",
        $fields: "files(id, name)",
      );
      final files = found.files;
      if (files == null) {
        return null;
      }
      // The folder already exists
      if (files.isNotEmpty) {
        return files.first.id;
      }

      // Create a folder
      var folder = drive.File();
      folder.name = defaultUserFolderName;
      folder.mimeType = mimeType;
      folder.parents = [defaultFileId];

      final folderCreation = await driveApi.files.create(folder);
      return folderCreation.id;
    } catch (e) {
      Log.e("get google dirve user folderId failed:${e.toString()}");
      return null;
    }
  }

  Future<String?> _getDefaultDirId(drive.DriveApi driveApi) async {
    const mimeType = "application/vnd.google-apps.folder";

    try {
      final found = await driveApi.files.list(
        q: "mimeType = '$mimeType' and name = '$_defaultDir'",
        $fields: "files(id, name)",
      );
      final files = found.files;
      if (files == null) {
        return null;
      }

      // The folder already exists
      if (files.isNotEmpty) {
        return files.first.id;
      }

      // Create a folder
      var folder = drive.File();
      folder.name = _defaultDir;
      folder.mimeType = mimeType;
      final folderCreation = await driveApi.files.create(folder);
      return folderCreation.id;
    } catch (e) {
      Log.e("get google dirve default folderId failed:${e.toString()}");
      return null;
    }
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;

  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}
