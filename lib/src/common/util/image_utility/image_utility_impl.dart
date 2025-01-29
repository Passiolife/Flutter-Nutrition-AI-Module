import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

import 'image_utility.dart';

class ImageUtilityImpl implements ImageUtility {
  @override
  Future<File> resize(File file, {int width = 150, int height = 150}) async {
    if (width <= 0 || height <= 0) {
      throw ArgumentError('Width and height must be greater than zero.');
    }

    String filePath = file.path;

    final message =
        _ResizeParams(filePath: file.path, width: width, height: height);
    final Uint8List resizedFileBytes = await compute(_resizeImage, message);

    String newPath = filePath.replaceAll(RegExp(r'\.[^\.]*$'), '_resized.jpg');
    File resizedFile = File(newPath);
    await resizedFile.writeAsBytes(resizedFileBytes);

    return resizedFile;
  }

  @override
  Future<Uint8List> resizeToUint8List(File file,
      {int width = 150, int height = 150}) async {
    // Validate dimensions
    if (width <= 0 || height <= 0) {
      throw ArgumentError('Width and height must be greater than zero.');
    }

    final message =
        _ResizeParams(filePath: file.path, width: width, height: height);
    final Uint8List resizedFileBytes = await compute(_resizeImage, message);

    return resizedFileBytes;
  }

  @override
  Future<Uint8List> resizeUint8List(Uint8List bytes,
      {int width = 150, int height = 150}) async {
    // Validate dimensions
    if (width <= 0 || height <= 0) {
      throw ArgumentError('Width and height must be greater than zero.');
    }

    final message = _ResizeParams(bytes: bytes, width: width, height: height);

    final Uint8List resizedFileBytes = await compute(_resizeImage, message);
    return resizedFileBytes;
  }

  Future<Uint8List> _resizeImage(_ResizeParams params) async {
    final paramsPath = params.filePath;
    final paramsBytes = params.bytes;

    if (paramsPath == null && paramsBytes == null) {
      throw ArgumentError('Either filePath or bytes must be provided.');
    }

    Uint8List bytes;
    if (paramsPath != null) {
      final File file = File(paramsPath);
      bytes = await file.readAsBytes();
    } else {
      bytes = paramsBytes!;
    }

    final img.Image? image = img.decodeImage(bytes);
    if (image == null) {
      throw Exception('Failed to decode image');
    }

    int imageWidth, imageHeight;
    if (image.width > image.height) {
      imageWidth = params.width;
      imageHeight = (image.height / image.width * params.width).round();
    } else {
      imageWidth = (image.width / image.height * params.height).round();
      imageHeight = params.height;
    }

    img.Image resizedImage =
        img.copyResize(image, width: imageWidth, height: imageHeight);

    final resizedBytes = img.encodeJpg(resizedImage);

    return resizedBytes;
  }

  @override
  Future<File> fixOrientation(File file, File destinationFile) async {
    final image = await decodeImageInBackground(file.path);
    if (image == null) {
      log('image_utility.dart: Failed to decode image from file ${file.path}');
      return file;
    }

    final img.Image fixedImage = await _fixOrientationInBackground(image);
    return await writeImageInBackground((
      destinationFile: destinationFile,
      encodeFunction: () => encodeJpgInBackground(fixedImage)
    ));
  }

  @override
  Future<Uint8List> fixOrientationToUint8List(File file) async {
    final image = await decodeImageInBackground(file.path);
    if (image == null) {
      log('image_utility.dart: Failed to decode image from file ${file.path}');
      return await file.readAsBytes();
    }

    final img.Image fixedImage = await _fixOrientationInBackground(image);
    return await encodeJpgInBackground(fixedImage);
  }

  Future<File> writeImage(
      ({
        File destinationFile,
        Future<Uint8List> Function() encodeFunction
      }) data) async {
    final bytes = await data.encodeFunction();
    return await data.destinationFile.writeAsBytes(bytes);
  }

  Future<File> writeImageInBackground(
      ({
        File destinationFile,
        Future<Uint8List> Function() encodeFunction
      }) data) async {
    return await compute(writeImage, data);
  }

  Uint8List encodeJpg(img.Image image) {
    return img.encodeJpg(image);
  }

  Future<Uint8List> encodeJpgInBackground(img.Image image) async {
    return await compute(encodeJpg, image);
  }

  Future<img.Image?> decodeImage(String path) async {
    return img.decodeImageFile(path);
  }

  Future<img.Image?> decodeImageInBackground(String path) async {
    return await compute(decodeImage, path);
  }

  Future<img.Image> _fixOrientation(img.Image image) async {
    return img.bakeOrientation(image);
  }

  Future<img.Image> _fixOrientationInBackground(img.Image image) async {
    return await compute(_fixOrientation, image);
  }
}

class _ResizeParams {
  final Uint8List? bytes;
  final String? filePath;
  final int width;
  final int height;

  const _ResizeParams({
    this.bytes,
    this.filePath,
    required this.width,
    required this.height,
  });
}
