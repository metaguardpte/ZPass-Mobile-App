import 'dart:async';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zpass/plugin_bridge/p7zip/p7zip.dart';
import 'package:zpass/util/log_utils.dart';

abstract class BaseFileTransferManager {
  final String defaultZipFileName = "db.7z";
  final String separator = Platform.pathSeparator;

  Future<String> doDownload(String userId);

  Future doUpload(String source, String userId);

  Future<String?> getStorageAccount();

  String getTransferType();

  ///zip file path in dedicated storage
  Future<String> download(String userId) async {
    String localZipFile = await doDownload(userId);
    try {
      String? decompressToPath =
          await P7zip.decompressZipToPath(fromZip: localZipFile);
      if (decompressToPath == null){
        String errorMessage = "Fail deCompress file: $localZipFile";
        Log.d(errorMessage);
        throw Exception(errorMessage);
      }

      Log.d("Finish decompress zip file to $decompressToPath");
      return decompressToPath;
    } finally {
      if (File(localZipFile).existsSync()) {
        File(localZipFile).delete();
      }
    }
  }

  ///source: directory that contains files to be archived
  Future upload(String source, String userId) async {
    var tempDir = await getTemporaryDirectory();
    String uniquePath = '${tempDir.path}$separator${getUniqueDir()}$separator';
    _copyDir(source, uniquePath);

    try {
      List<String> toBeArchivedFiles = <String>[];
      List<FileSystemEntity> tempFiles = Directory(uniquePath).listSync();
      for (FileSystemEntity f in tempFiles) {
        if (FileSystemEntity.isDirectorySync(f.path)) {
          continue;
        }
        toBeArchivedFiles.add(f.path);
      }
      String zipFilePath = '$uniquePath$defaultZipFileName';
      String? compressedFile = await P7zip.compressFileListToZip(
          files: toBeArchivedFiles, toZip: zipFilePath);

      if (compressedFile == null) {
        String errorMessage = "Fail compress files: $toBeArchivedFiles";
        Log.d(errorMessage);
        throw Exception(errorMessage);
      } else {
        Log.d("Success compress files: $toBeArchivedFiles to $compressedFile");
        await doUpload(compressedFile, userId);
      }
    } finally {
      deleteTempAssets(uniquePath);
    }
  }

  Future deleteTempAssets(String path) async {
    var dir = Directory(path);
    if (dir.existsSync()){
      return dir.delete(recursive: true);
    }
  }

  String getUniqueDir() {
    return DateFormat("yyyy-MM-dd-hhmmss").format(DateTime.now());
  }

  void _copyDir(String fromDir, String toDir) {
    Directory newDir = Directory(toDir);
    newDir.createSync(recursive: true);

    List<FileSystemEntity> fileList = Directory(fromDir).listSync();

    for (FileSystemEntity f in fileList) {
      if (FileSystemEntity.isDirectorySync(f.path)) {
        continue;
      }
      String path = f.path;
      var lastSeparator = path.lastIndexOf(separator);
      var fileName = path.substring(lastSeparator + 1, path.length);

      File("$toDir$separator$fileName")
          .writeAsBytesSync(File(path).readAsBytesSync());
    }
  }
}
