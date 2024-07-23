import 'dart:io';
import 'dart:typed_data';

class FileUtility {
  static Future<File> writeFile(String path, List<int> bytes) async {
    final file = File(path);
    return await file.writeAsBytes(bytes);
  }

  static Future<File> updateFile(String path, List<int> bytes) async {
    await File(path).delete();
    return writeFile(path, bytes);
  }

  static Future<Uint8List> readFile(String path) async {
    return await File(path).readAsBytes();
  }
}
