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

  ///zip file path in dedicated storage
  Future<String?> download(String userId) async {
    String localZipFile = await doDownload(userId);
    try {
      String? decompressToPath = await P7zip.decompressZipToPath(fromZip: localZipFile);
      Log.d("Finish decompress zip file to $decompressToPath");
      return decompressToPath;
    } catch (e) {
      Log.e("decompress zip file failed after download:${e.toString()}");
    }
    if (File(localZipFile).existsSync()){
      File(localZipFile).delete();
    }

    return null;
  }

  ///source: directory that contains files to be archived
  Future upload(String source, String userId) async {
    var tempDir = await getTemporaryDirectory();
    String uniquePath = '${tempDir.path}$separator${getUniqueDir()}$separator';
    copyDir(source, uniquePath);

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
      String? compressedFile = await P7zip.compressFileListToZip(files: toBeArchivedFiles, toZip: zipFilePath);
      Log.d("Finish compress files: $toBeArchivedFiles to $compressedFile");

      await doUpload(compressedFile!, userId);
    }catch (e) {
      Log.e("upload to google dirve failed:${e.toString()}");
    }

    Directory(uniquePath).delete(recursive: true);
  }

  String getUniqueDir(){
    return DateFormat("yyyy-MM-dd-hhmmss").format(DateTime.now());
  }

  void copyDir(String fromDir, String toDir){
    Directory newDir = Directory(toDir);
    newDir.createSync(recursive: true);

    List<FileSystemEntity> fileList = Directory(fromDir).listSync();

    for(FileSystemEntity f in fileList){
      if (FileSystemEntity.isDirectorySync(f.path)) {
        continue;
      }
      String path = f.path;
      var lastSeparator = path.lastIndexOf(separator);
      var fileName = path.substring(lastSeparator + 1, path.length);

      File("$toDir$separator$fileName").writeAsBytesSync(File(path).readAsBytesSync());
    }
  }

}