/*
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/adaptive_action_button_widget.dart';

abstract interface class LifecycleHandler {
  void onResume();
}

abstract interface class PermissionCallback {
  void onPermissionGranted(Permission permission);

  void onPermissionDenied(Permission permission);
}

abstract interface class PermissionManagerUtility {
  Future<bool> requestPermission(Permission permission);

  Future<bool> hasPermission(Permission permission);

  Future<void> requestPermissionWithSettingsDialog({
    required BuildContext context,
    required Permission permission,
    String? title,
    String? description,
  });
}

class PermissionManagerUtilityImpl
    implements PermissionManagerUtility, LifecycleHandler {
  final PermissionCallback? callback;

  PermissionManagerUtilityImpl({this.callback});

  static Permission? _lastPermission;
  static BuildContext? _dialogContext;

  @override
  Future<bool> requestPermission(Permission permission) async {
    var status = await permission.request();
    return _hasPermission(status);
  }

  @override
  Future<void> requestPermissionWithSettingsDialog({
    required BuildContext context,
    required Permission permission,
    String? title,
    String? description,
    ValueChanged<Permission>? onTapCancelForSettings,
  }) async {
    _lastPermission = permission;
    var status = await permission.request();
    if (_isDenied(status) && context.mounted) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          _dialogContext = context;
          return SettingDialogWidget(
            title: title,
            description: description,
            onTapNegative: () {
              onTapCancelForSettings?.call(permission);
            },
          );
        },
      ).then((_) {
        _dialogContext = null;
      });
    }
  }

  @override
  Future<bool> hasPermission(Permission permission) async {
    var status = await permission.status;
    return _hasPermission(status);
  }

  bool _isDenied(PermissionStatus status) {
    return status.isDenied || status.isPermanentlyDenied;
  }

  bool _hasPermission(PermissionStatus status) {
    return status.isGranted || status.isLimited;
  }

  @override
  void onResume() async {
    final status = await _lastPermission?.status;
    if (status != null && _hasPermission(status)) {
      callback?.onPermissionGranted(_lastPermission!);
      if (_dialogContext != null && _dialogContext!.mounted) {
        Navigator.pop(_dialogContext!);
        _dialogContext = null;
        _lastPermission = null;
      }
    } else {
      callback?.onPermissionDenied(_lastPermission!);
    }
  }
}

mixin PermissionManagerLifeCycleMixin<T extends StatefulWidget> on State<T> {
  LifecycleHandler? _lifecycleHandler;
  AppLifecycleListener? _appLifecycleListener;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addObserver(this);
    _appLifecycleListener =
        AppLifecycleListener(onStateChange: didChangeAppLifecycleState);
    // Use the factory to create and assign the permission manager
    _lifecycleHandler = PermissionManagerUtilityImpl();
  }

  @override
  void dispose() {
    _appLifecycleListener?.dispose();
    _appLifecycleListener = null;
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _lifecycleHandler?.onResume();
        break;
      default:
        break;
    }
  }
}

*/
