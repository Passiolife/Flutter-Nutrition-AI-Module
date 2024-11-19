import 'dart:io';
import 'dart:typed_data';

class FileUtility {
  static Future<File> writeFile(String path, List<int> bytes) async {
    final file = File(path);
    return await file.writeAsBytes(bytes);
  }

  static Future<File> updateFile(String path, List<int> bytes) async {
    await deleteFile(path);
    return writeFile(path, bytes);
  }

  static Future deleteFile(String path) async {
    if(await existsFile(path)) {
      return;
    }
    return await File(path).delete();
  }

  static Future<bool> existsFile(String path) async {
    return await File(path).exists();
  }

  static Future<Uint8List> readFile(String path) async {
    return await File(path).readAsBytes();
  }
}
