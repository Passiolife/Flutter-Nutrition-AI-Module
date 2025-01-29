import 'dart:io';
import 'dart:typed_data';

abstract class ImageUtility {

  /// Resizes an image file and returns the resized image as a new file.
  Future<File> resize(File file, {int width = 150, int height = 150});

  /// Resizes an image file and returns the resized image as a Uint8List.
  Future<Uint8List> resizeToUint8List(File file,
      {int width = 150, int height = 150});

  Future<Uint8List> resizeUint8List(Uint8List bytes, {int width = 150, int height = 150});

  Future<File> fixOrientation(File file, File destinationFile);

  Future<Uint8List> fixOrientationToUint8List(File file);
}