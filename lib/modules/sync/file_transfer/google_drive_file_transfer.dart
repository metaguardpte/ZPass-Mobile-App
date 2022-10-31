
import 'dart:core';
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart' as signIn;
import 'package:path_provider/path_provider.dart';
import 'package:zpass/modules/sync/file_transfer/base_file_transfer.dart';
import "package:http/http.dart" as http;
import 'package:_discoveryapis_commons/_discoveryapis_commons.dart' as commons;
import 'package:zpass/util/log_utils.dart';


class GoogleDriveFileTransferManager extends BaseFileTransferManager {
  drive.DriveApi? _driveApi;
  final _defaultDir = "zpass";

  @override
  Future<String> doDownload() async {
    if (_driveApi == null){
      await _signinUser();
    }

    String? fileId = await getDefaultFileId(_driveApi!);
    Object result = await _driveApi!.files.get(fileId!, downloadOptions: commons.DownloadOptions.fullMedia);
    result as commons.Media;

    List<int> dataStore = [];
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    String uniqueFile = "${getUniqueDir()}.7z";

    await result.stream.listen((data) {
      dataStore.insertAll(dataStore.length, data);
    }, onDone: () async {
      File file = File('$tempPath/$uniqueFile');
      await file.writeAsBytes(dataStore);
    }, onError: (error) {
      Log.e("download $fileId from google dirve failed:${error.toString()}");
    });

    return uniqueFile;
  }

  @override
  Future doUpload(String source, {String dest = ''}) async {
    if (_driveApi == null){
      await _signinUser();
    }

    File sourceFile = File(source);
    drive.File fileToUpload = drive.File();
    fileToUpload.name = defaultZipFileName;
    if (dest.isEmpty) {
      String? folderId = await _getFolderId(_driveApi!);
      fileToUpload.parents = [folderId!];
    }
    try {
      await _driveApi?.files.create(
        fileToUpload,
        uploadMedia: drive.Media(sourceFile.openRead(), sourceFile.lengthSync()),
      );
    }catch (e) {
      Log.e("upload to google dirve failed:${e.toString()}");
    }
  }

  Future _signinUser() async {
    final googleSignIn =
    signIn.GoogleSignIn.standard(scopes: [drive.DriveApi.driveScope]);
    GoogleSignInAccount? account = await googleSignIn.signIn();
    final authHeaders = await account!.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    _driveApi = drive.DriveApi(authenticateClient);
  }

  Future<String?> getDefaultFileId(drive.DriveApi driveApi) async {
    final folderId = await _getFolderId(driveApi);
    drive.FileList fileList = await driveApi.files.list(
      spaces: 'drive',
      q: "'$folderId' in parents",
    );

    var myListFiltered = fileList.files!.where((e) => e.name == defaultZipFileName);
    if (myListFiltered.isEmpty) {
      return null;
    } else {
      return myListFiltered.first.id;
    }
  }

  Future<String?> _getFolderId(drive.DriveApi driveApi) async {
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
      Log.e("get google dirve folderId failed:${e.toString()}");
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