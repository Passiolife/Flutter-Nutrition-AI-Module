part of '../permission_manager.dart';

abstract class LifecycleHandler {
  void onResume();
}

abstract class PermissionCallback {
  void onPermissionGranted(Permission permission);
  void onPermissionDenied(Permission permission);
}

abstract class PermissionManagerUtility {
  Future<bool> requestPermission(Permission permission);
  Future<bool> hasPermission(Permission permission);
  Future<void> requestPermissionWithSettingsDialog({
    required BuildContext context,
    required Permission permission,
    String? title,
    String? description,
    ValueChanged<Permission>? onTapCancelForSettings,
  });
}