import 'dart:developer';

import 'package:camera/camera.dart';

class CameraControllerSingleton {
  factory CameraControllerSingleton() {
    return _instance;
  }

  CameraControllerSingleton._internal();
  static final CameraControllerSingleton _instance =
  CameraControllerSingleton._internal();

  CameraController? _cameraController;
  XFile? _capturedPicture;

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final camera = cameras.first;

    _cameraController = CameraController(
      camera,
      ResolutionPreset.veryHigh,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await _cameraController!.initialize();
  }

  CameraController? get cameraController => _cameraController;
  XFile? get picture => _capturedPicture;


  Future<XFile?> takePicture() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        _capturedPicture = await _cameraController!.takePicture();
        return picture;
      } catch (e) {
        log('Error taking picture: $e');
      }
    }
    return null;
  }

  bool isCameraRunning() =>
      _cameraController != null && _cameraController!.value.isInitialized;

  void startCamera() {
    if (_cameraController != null &&
        !_cameraController!.value.isStreamingImages) {
      _cameraController!.startImageStream((CameraImage image) {
        // Process camera frames here
      });
    }
  }

  void stopCamera() {
    if (_cameraController != null &&
        _cameraController!.value.isStreamingImages) {
      _cameraController!.stopImageStream();
    }
  }

  void clearPicture() {
    _capturedPicture = null;
  }

  void disposeCamera() {
    _cameraController?.dispose();
  }
}