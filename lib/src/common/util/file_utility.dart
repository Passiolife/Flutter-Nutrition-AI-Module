import 'dart:io';
import 'dart:typed_data';

// Define the interface
abstract interface class FileUtility {
  Future<File> writeFile(String path, List<int> bytes);

  Future<File> updateFile(String path, List<int> bytes);

  Future<void> deleteFile(String path);

  Future<bool> existsFile(String path);

  Future<Uint8List> readFile(String path);

  // Factory constructor to return the Singleton instance
  factory FileUtility() => _FileUtilityImpl.instance;
}

// Implement the interface
class _FileUtilityImpl implements FileUtility {
  // Private constructor to enforce Singleton pattern
  _FileUtilityImpl._privateConstructor();

  // The single instance of the class
  static final _FileUtilityImpl instance =
      _FileUtilityImpl._privateConstructor();

  /// Writes a file with the given bytes at the specified path
  @override
  Future<File> writeFile(String path, List<int> bytes) async {
    try {
      File file = File(path);
      if (!file.existsSync()) {
        file = await file.create(recursive: true);
      }
      return await file.writeAsBytes(bytes,
          flush: true); // Ensuring data is flushed
    } catch (e) {
      throw FileSystemException("Failed to write file at $path", e.toString());
    }
  }

  /// Updates a file by rewriting it
  @override
  Future<File> updateFile(String path, List<int> bytes) async {
    try {
      return await writeFile(path, bytes);
    } catch (e) {
      throw FileSystemException("Failed to update file at $path", e.toString());
    }
  }

  /// Deletes a file at the given path if it exists
  @override
  Future<void> deleteFile(String path) async {
    if (await existsFile(path)) {
      try {
        await File(path).delete();
      } catch (e) {
        throw FileSystemException(
            "Failed to delete file at $path", e.toString());
      }
    }
  }

  /// Checks if a file exists at the specified path
  @override
  Future<bool> existsFile(String path) async {
    try {
      return File(path).exists();
    } catch (e) {
      throw FileSystemException(
          "Failed to check file existence at $path", e.toString());
    }
  }

  /// Reads a file's content as bytes from the specified path
  @override
  Future<Uint8List> readFile(String path) async {
    try {
      return await File(path).readAsBytes();
    } catch (e) {
      throw FileSystemException("Failed to read file at $path", e.toString());
    }
  }
}
