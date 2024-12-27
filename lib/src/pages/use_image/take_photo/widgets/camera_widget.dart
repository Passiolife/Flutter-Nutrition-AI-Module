import 'dart:async';
import 'dart:developer';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../common/extension/context_extension.dart';
import '../../../../common/util/permission_manager_utility.dart';
import '../../../../common/util/snackbar_extension.dart';
import '../../../../common/widgets/adaptive_loader.dart';

class CameraWidget extends StatefulWidget {
  const CameraWidget({
    this.resolution = ResolutionPreset.max,
    super.key,
  });

  final ResolutionPreset resolution;

  @override
  State<CameraWidget> createState() => CameraWidgetState();
}

class CameraWidgetState extends State<CameraWidget> {
  // Listener for app lifecycle changes
  AppLifecycleListener? _lifecycleListener;

  CameraController? _controller;
  String _error = '';

  // Instance of PermissionManagerUtility to handle permissions
  final PermissionManagerUtility _permissionManager =
      PermissionManagerUtility();

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
        return Positioned.fill(
          child: CameraPreview(_controller!),
        );
      } else {
        return const Align(
          alignment: Alignment.center,
          child: AdaptiveLoader(),
        );
      }
    }
  }

  void _initialize() {
    _lifecycleListener = AppLifecycleListener(
      // Callback function triggered on app lifecycle state change
      onStateChange: (state) {
        // Call permission manager to handle app lifecycle state change
        _permissionManager.didChangeAppLifecycleState(state);
        _handleAppLifecycleState(state);
      },
    );
    _checkPermission();
  }

  // Check camera permission
  Future _checkPermission() async {
    await PermissionManagerUtility().request(
      context,
      Permission.camera,
      title: context.localization?.permission,
      message: context.localization?.cameraPermissionMessage,
      onTapCancelForSettings: (contextPermission) {
        Navigator.pop(contextPermission);
        Navigator.pop(context);
      },
      onUpdateStatus: (Permission? permission) async {
        if ((await permission?.isGranted) ?? false) {
          _initializeCamera();
        }
      },
    );
  }

  void _handleAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCameraController(cameraController.description);
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await getAvailableCameras();
      if (cameras.isNotEmpty) {
        _initializeCameraController(cameras.first);
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
            text: 'Camera error ${cameraController.value.errorDescription}');
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
        context.showSnackbar(text: 'You have denied camera access.');
      case 'CameraAccessDeniedWithoutPrompt':
        // iOS only
        context.showSnackbar(
            text: 'Please go to Settings app to enable camera access.');
      case 'CameraAccessRestricted':
        // iOS only
        context.showSnackbar(text: 'Camera access is restricted.');
      case 'AudioAccessDenied':
        context.showSnackbar(text: 'You have denied audio access.');
      case 'AudioAccessDeniedWithoutPrompt':
        // iOS only
        context.showSnackbar(
            text: 'Please go to Settings app to enable audio access.');
      case 'AudioAccessRestricted':
        // iOS only
        context.showSnackbar(text: 'Audio access is restricted.');
      default:
        _showCameraException(e);
        break;
    }
  }

  void _showCameraException(CameraException e) {
    log('${e.code}, ${e.description}');
    context.showSnackbar(text: 'Error: ${e.code}\n${e.description}');
  }

  CameraController? getController() {
    return _controller;
  }

  Future<List<CameraDescription>> getAvailableCameras() async {
    return await availableCameras();
  }
}
