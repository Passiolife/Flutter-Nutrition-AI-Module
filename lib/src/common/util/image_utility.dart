import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

import 'isolate_utility.dart';

abstract class ImageUtility {
  /// Resizes an image file and returns the resized image as a new file.
  Future<File> resize(File file, {int width = 150, int height = 150});
  /// Resizes an image file and returns the resized image as a Uint8List.
  Future<Uint8List> resizeToUint8List(File file, {int width = 150, int height = 150});
  // Future<Uint8List> resizeUint8List(Uint8List bytes, {int width = 150, int height = 150});
}

class ImageUtilityImpl implements ImageUtility {

  @override
  Future<File> resize(File file,
      {int width = 150, int height = 150}) async {
    // Validate dimensions
    if (width <= 0 || height <= 0) {
      throw ArgumentError('Width and height must be greater than zero.');
    }

    String filePath = file.path;

    // final isolateUtility = IsolateUtility();

    // Prepare data for the isolate
    final receivePort = ReceivePort();
    await Isolate.spawn(_resizeImage, _ResizeParams(receivePort.sendPort, filePath, width, height));

    // Receive the processed image file bytes from the isolate
    final Uint8List resizedFileBytes = await receivePort.first as Uint8List;

    String newPath = filePath.replaceAll(RegExp(r'\.[^\.]*$'), '_resized.jpg');
    File resizedFile = File(newPath);
    await resizedFile.writeAsBytes(resizedFileBytes);

    return resizedFile;
  }

  @override
  Future<Uint8List> resizeToUint8List(File file, {int width = 150, int height = 150}) async {
    // Validate dimensions
    if (width <= 0 || height <= 0) {
      throw ArgumentError('Width and height must be greater than zero.');
    }

    // Prepare data for the isolate
    final receivePort = ReceivePort();
    await Isolate.spawn(_resizeImage, _ResizeParams(receivePort.sendPort, file.path, width, height));

    // Receive the processed image file bytes from the isolate
    final Uint8List resizedFileBytes = await receivePort.first as Uint8List;

    return resizedFileBytes;
  }

  void _resizeImage(_ResizeParams params) async {
    final File file = File(params.filePath);
    final Uint8List bytes = await file.readAsBytes();
    final img.Image? image = img.decodeImage(bytes);
    if (image == null) {
      throw Exception('Failed to decode image');
    }

    // Calculate new dimensions preserving aspect ratio
    int imageWidth, imageHeight;
    if (image.width > image.height) {
      imageWidth = params.width;
      imageHeight = (image.height / image.width * params.width).round();
    } else {
      imageWidth = (image.width / image.height * params.height).round();
      imageHeight = params.height;
    }

    // Resize the image
    img.Image resizedImage =
    img.copyResize(image, width: imageWidth, height: imageHeight);

    // Encode the image in the same format as the original
    final resizedBytes = img.encodeJpg(resizedImage);
    // String newPath =
    //     params.filePath.replaceAll(RegExp(r'\.[^\.]*$'), '_resized.jpg');
    // File resizedFile = File(newPath);
    // await resizedFile.writeAsBytes(resizedBytes);

    // Send the result back to the main thread
    params.sendPort.send(resizedBytes);
  }

}

class _ResizeParams {
  final SendPort sendPort;
  final String filePath;
  final int width;
  final int height;

  const _ResizeParams(this.sendPort, this.filePath, this.width, this.height);
}
