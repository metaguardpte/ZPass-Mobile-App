
abstract class BaseFileTransferManager {
  String download(String source);
  String copyAndZip(String source);
  void upload(String source, String dest);
}