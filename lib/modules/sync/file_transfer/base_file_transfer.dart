import 'dart:async';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:zpass/plugin_bridge/p7zip/p7zip.dart';

abstract class BaseFileTransferManager {

  final String defaultZipFileName = "zpass.7z";

  Future<String> doDownload();

  Future doUpload(String source, {String dest=''});

  ///zip file path in dedicated storage
  Future<String> download() async {
    String localZipFile = await doDownload();
    String? decompressToPath = await P7zip.decompressZipToPath(fromZip: localZipFile);
    return decompressToPath!;
  }

  ///source: directory that contains files to be archived
  Future upload(String source) async {
    final tempDir = await getTemporaryDirectory();
    String tempPath = "$tempDir/${getUniqueDir()}";
    copyDir(source, tempPath);

    String zipFilePath = "$tempPath/$defaultZipFileName";
    await P7zip.compressPathToZip(fromPath: tempPath, toZip: zipFilePath);
    doUpload(zipFilePath);
  }

  String getUniqueDir(){
    return DateFormat("yyyy-MM-dd-hhmmss").format(DateTime.now());
  }

  void copyDir(String fromDir, String toDir){
    Directory newDir = Directory(toDir);
    newDir.createSync(recursive: true);

    List<FileSystemEntity> fileList = Directory(fromDir).listSync();
    for(FileSystemEntity f in fileList){
      File("$toDir/${f.path}").writeAsBytesSync(File(f.path).readAsBytesSync());
    }
  }

}