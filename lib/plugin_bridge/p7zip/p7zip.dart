import 'package:p7zip/p7zip.dart';

class P7zip {

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

    return decompress(fromZip, toPath);
  }

  static String getDefaultDecompressPath(String fromZip) {
    int zipSuffix = fromZip.lastIndexOf(".");
    return fromZip.substring(0, zipSuffix -1);
  }
}