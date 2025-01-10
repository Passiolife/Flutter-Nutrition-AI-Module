import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../extension/context_extension.dart';
import '../../util/snackbar_extension.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({
    this.lensDirection = CameraLensDirection.back,
    this.resolution = ResolutionPreset.max,
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

  CameraController? _controller;
  String _error = '';

  List<CameraDescription> _cameras = [];

  CameraLensDirection? _lensDirection;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _lifecycleListener?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_error.isNotEmpty) {
      return Align(
        alignment: Alignment.center,
        child: Text(_error),
      );
    } else {
      if (_controller != null) {
        return SizedBox(
          width: context.width,
          height: context.height,
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              height: context.width,
              child: CameraPreview(_controller!), // Displays the camera preview
            ),
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    }
  }

  void _initialize() {
    _lensDirection = widget.lensDirection;
    _lifecycleListener = AppLifecycleListener(
      // Callback function triggered on app lifecycle state change
      onStateChange: (state) {
        _handleAppLifecycleState(state);
      },
    );
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _initializeCamera();
    });
  }

  void _handleAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCameraController(cameraController.description);
    }
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await getAvailableCameras();
      if (_cameras.isNotEmpty) {
        final description = _cameras.firstWhere(
            (e) => e.lensDirection == _lensDirection,
            orElse: () => _cameras.first);
        _initializeCameraController(description);
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  Future<void> _initializeCameraController(
      CameraDescription cameraDescription) async {
    final CameraController cameraController = CameraController(
      cameraDescription,
      widget.resolution,
      imageFormatGroup: ImageFormatGroup.jpeg,
      enableAudio: false,
    );

    _controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        context.showSnackbar(
            text:
                '${context.localization.error} ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      if (mounted) {
        _handleCameraException(e);
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _handleCameraException(CameraException e) {
    switch (e.code) {
      case 'CameraAccessDenied':
        context.showSnackbar(
            text: context.localization.youHaveDeniedCameraAccess);
      case 'CameraAccessDeniedWithoutPrompt':
        // iOS only
        context.showSnackbar(
            text:
                context.localization.pleaseGoToSettingsAppToEnableCameraAccess);
      case 'CameraAccessRestricted':
        // iOS only
        context.showSnackbar(
            text: context.localization.cameraAccessIsRestricted);
      case 'AudioAccessDenied':
        context.showSnackbar(
            text: context.localization.youHaveDeniedAudioAccess);
      case 'AudioAccessDeniedWithoutPrompt':
        // iOS only
        context.showSnackbar(
            text:
                context.localization.pleaseGoToSettingsAppToEnableAudioAccess);
      case 'AudioAccessRestricted':
        // iOS only
        context.showSnackbar(
            text: context.localization.audioAccessIsRestricted);
      default:
        _showCameraException(e);
        break;
    }
  }

  void _showCameraException(CameraException e) {
    log('${e.code}, ${e.description}');
    context.showSnackbar(
        text: '${context.localization.error}: ${e.code}\n${e.description}');
  }

  CameraController? getController() {
    return _controller;
  }

  Future<List<CameraDescription>> getAvailableCameras() async {
    return await availableCameras();
  }

  Future<XFile?> takePicture() async {
    return _controller?.takePicture();
  }

  Future<void> enableFlashlight({required FlashMode mode}) async {
    try {
      return await _controller?.setFlashMode(mode);
    } on CameraException catch (e) {
      if (e.code == 'setFlashModeFailed') {
        if (_lensDirection == CameraLensDirection.front) {
          context.showSnackbar(
              text: context.localization
                  .frontCameraFlashlightIsNotSupportedOnThisDevice);
        }
      }
    }
  }

  Future<void> changeCameraLens(CameraLensDirection lensDirection) async {
    _lensDirection = lensDirection;
    await _initializeCamera();
  }
}
