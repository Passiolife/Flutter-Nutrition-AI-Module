import 'dart:io';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

enum ImagePickerSource {
  /// Opens up the device camera, letting the user to take a new picture.
  camera,

  /// Opens the user's photo gallery.
  gallery,
}

abstract class ImagePickerService {
  Future<File?> pickImage(ImagePickerSource source);

  Future<Uint8List?> pickImageAsBytes(ImagePickerSource source);

  Future<List<File>> pickMultiImage(int limit);

  Future<List<Uint8List>> pickMultiImageAsBytes(int limit);

  Future<List<Uint8List>> convertFilesToBytes(List<File> files);
}

class ImagePickerServiceImpl implements ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  @override
  Future<File?> pickImage(ImagePickerSource source) async {
    final xFile = await _picker.pickImage(
        source: source == ImagePickerSource.camera
            ? ImageSource.camera
            : ImageSource.gallery);
    if (xFile == null) {
      return null;
    }
    return File(xFile.path);
  }

  @override
  Future<List<File>> pickMultiImage(int limit) async {
    List<XFile> xFile = await _picker.pickMultiImage(limit: limit);
    return xFile.map((e) => File(e.path)).toList();
  }

  @override
  Future<Uint8List?> pickImageAsBytes(ImagePickerSource source) async {
    final pickedFile = await _picker.pickImage(
        source: source == ImagePickerSource.camera
            ? ImageSource.camera
            : ImageSource.gallery);
    return pickedFile?.readAsBytes();
  }

  @override
  Future<List<Uint8List>> pickMultiImageAsBytes(int limit) async {
    final pickedImageFiles = await _picker.pickMultiImage(limit: limit);
    final imageFiles = pickedImageFiles.map((e) => File(e.path)).toList();
    return convertFilesToBytes(imageFiles);
  }

  @override
  Future<List<Uint8List>> convertFilesToBytes(List<File> files) async {
    final fileByteFutures = files.map((e) => e.readAsBytes()).toList();
    final byteArrays = await Future.wait(fileByteFutures);
    return byteArrays;
  }
}
