import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../extension/context_extension.dart';
import '../../util/camera_controller_singleton.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({
    this.lensDirection = CameraLensDirection.back,
    this.resolution = ResolutionPreset.veryHigh,
    super.key,
  });

  final CameraLensDirection lensDirection;
  final ResolutionPreset resolution;

  @override
  State<CameraWidget> createState() => CameraWidgetState();
}

class CameraWidgetState extends State<CameraWidget> {
  // Listener for app lifecycle changes
  AppLifecycleListener? _lifecycleListener;

  final CameraControllerSingleton _cameraControllerSingleton =
      CameraControllerSingleton();
  CameraController? _cameraController;
  Future<void>? _initializeCameraFuture;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _lifecycleListener?.dispose();
    if (Platform.isIOS) {
      _cameraControllerSingleton
        ..clearPicture()
        ..disposeCamera();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeCameraFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return SizedBox(
            width: context.width,
            height: context.height,
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                height: context.width,
                child: CameraPreview(_cameraController!),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  Future<void> _initialize() async {
    await _cameraControllerSingleton.initializeCamera();
    _lifecycleListener = AppLifecycleListener(
      // Callback function triggered on app lifecycle state change
      onStateChange: (state) {
        _handleAppLifecycleState(state);
      },
    );
    _cameraController = _cameraControllerSingleton.cameraController;
    _initializeCameraFuture = _cameraController?.initialize();
    if (_cameraController!.value.isInitialized) {
      setState(() {});
    }
  }

  void _handleAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (_cameraController == null ||
        !(_cameraController?.value.isInitialized ?? false)) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      _cameraController!.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _cameraController?.initialize();
    }
  }

  CameraController? getController() {
    return _cameraController;
  }

  Future<List<CameraDescription>> getAvailableCameras() async {
    return await availableCameras();
  }

  Future<XFile?> takePicture() async {
    return _cameraController?.takePicture();
  }
}
