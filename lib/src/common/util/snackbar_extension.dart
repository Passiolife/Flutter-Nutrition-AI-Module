import 'package:flutter/material.dart';

extension SnackbarExtension on BuildContext {
  void showSnackbar({
    String? text,
    String? actionLabel,
    VoidCallback? onPressAction,
  }) {
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(getSnackBar(text: text, actionLabel: actionLabel, onPressAction: onPressAction));
  }
}

extension SnackbarStateExtension on ScaffoldMessengerState {
  void showSnackbar({
    String? text,
    String? actionLabel,
    VoidCallback? onPressAction,
  }) {
    showSnackBar(getSnackBar(text: text, actionLabel: actionLabel, onPressAction: onPressAction));
  }
}

SnackBar getSnackBar({
  String? text,
  String? actionLabel,
  VoidCallback? onPressAction,
}) {
  SnackBar? snackBar;
  if (actionLabel != null) {
    snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 2000),
      content: Text(text ?? ''),
      action: SnackBarAction(
        label: actionLabel,
        onPressed: () => onPressAction?.call(),
      ),
    );
  } else {
    snackBar = SnackBar(
      content: Text(text ?? ''),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 2000),
    );
  }
  // Find the ScaffoldMessenger in the widget tree
  // and use it to show a SnackBar.
  return snackBar;
}
