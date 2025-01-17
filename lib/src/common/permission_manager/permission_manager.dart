import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/adaptive_action_button_widget.dart';

part 'interfaces/permission_interfaces.dart';
part 'mixins/lifecycle_mixin.dart';
part 'widgets/setting_dialog_widget.dart';

class PermissionManagerUtilityImpl
    implements PermissionManagerUtility, LifecycleHandler {
  final PermissionCallback? callback;

  const PermissionManagerUtilityImpl({this.callback});

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
    if (_hasPermission(status)) {
      callback?.onPermissionGranted(permission);
    } else if (_isDenied(status) && context.mounted) {
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
      if (_dialogContext != null && _dialogContext!.mounted) {
        Navigator.pop(_dialogContext!);
        _dialogContext = null;
        _lastPermission = null;
      }
      callback?.onPermissionGranted(_lastPermission!);
    } else {
      callback?.onPermissionDenied(_lastPermission!);
    }
  }
}
