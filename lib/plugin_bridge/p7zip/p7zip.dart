import 'dart:io';

import 'package:p7zip/p7zip.dart';

class P7zip {

  /// files in this directory(fromPath) would be compressed to file(toZip)
  /// return toZip if success
  static Future<String?> compressFileListToZip({required List<String> files, required String toZip}) async {
    if (files.isEmpty || toZip.isEmpty) {
      return null;
    }

    return compressFiles(files, toZip);
  }

  /// files in this directory(fromPath) would be compressed to file(toZip)
  /// return toZip if success
  static Future<String?> compressPathToZip({required String fromPath, required String toZip}) async {
    if (fromPath.isEmpty || toZip.isEmpty) {
      return null;
    }

    return compressPath(fromPath, toZip);
  }

  ///zip file(fromZip) would be extracted to directory(toPath)
  ///if directory:toPath isNotExist, will be created automatically
  ///return toPath if success
  static Future<String?> decompressZipToPath({required String fromZip, String toPath = ''}) async {
    if (fromZip.isEmpty) {
      return null;
    }
    if (toPath.isEmpty) {
      toPath = getDefaultDecompressPath(fromZip);
    }

    var extractTo = await decompress(fromZip, toPath);
    if (extractTo == null) {
      return null;
    }
    var directory = Directory(extractTo);
    List<FileSystemEntity> fileList = directory.listSync();
    for (FileSystemEntity f in fileList) {
      if (FileSystemEntity.isDirectorySync(f.path)) {
        return f.path;
      }
    }

    return extractTo;
  }

  static String getDefaultDecompressPath(String fromZip) {
    int zipSuffix = fromZip.lastIndexOf(".");
    return fromZip.substring(0, zipSuffix);
  }
}