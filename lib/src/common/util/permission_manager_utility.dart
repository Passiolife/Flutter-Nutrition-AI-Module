import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/adaptive_action_button_widget.dart';

typedef PermissionCallback = Function(Permission? permission);

typedef OnTapCancel = Function(BuildContext context);

class PermissionManagerUtility {
  /// This flag will update once the setting is opened after permission denied.
  static bool _openedSetting = false;
  static PermissionCallback? _permissionCallback;
  static Permission? _permission;
  static BuildContext? _dialogContext;

  Future didChangeAppLifecycleState(AppLifecycleState state) async {
    /// This block executes if state is resumed.
    if (state == AppLifecycleState.resumed && _openedSetting) {
      _openedSetting = false;
      if ((await _permission?.isGranted ?? false) ||
          (await _permission?.isLimited ?? false)) {
        if (_dialogContext != null) {
          Navigator.pop(_dialogContext!);
          _dialogContext = null;
        }
      }
      _permissionCallback?.call(_permission);
    }
  }

  /// Here we are requesting the permission.
  ///
  /// [askForSettings] will open the setting screen if we are denying the permissions.
  /// default value is 'true'.
  ///
  Future request(
    BuildContext context,
    Permission permission, {
    bool askForSettings = true,
    PermissionCallback? onUpdateStatus,
    String? title,
    String? message,
    OnTapCancel? onTapCancelForSettings,
  }) async {
    _dialogContext = null;
    _permissionCallback = onUpdateStatus;
    _permission = permission;
    PermissionStatus result = await permission.request();

    if (result.isGranted) {
      _permissionCallback?.call(_permission);
    } else if ((result.isDenied || result.isPermanentlyDenied) &&
        askForSettings) {
      if (context.mounted) {
        showDialog<String>(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            _dialogContext = context;
            return AlertDialog.adaptive(
              title: Text(title ?? 'Permission'),
              content: Text(message ?? 'Please allow permission access.'),
              actions: <Widget>[
                adaptiveAction(
                  context: context,
                  onPressed: () =>
                      onTapCancelForSettings?.call(context) ??
                      Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                adaptiveAction(
                  context: context,
                  onPressed: () async {
                    _openedSetting = await openAppSettings();
                  },
                  child: const Text('Open Settings'),
                ),
              ],
            );
          },
        );
      }
    }
  }
}
