import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_constants.dart';

extension SnackbarExtension on BuildContext {
  void showSnackbar({
    String? text,
    String? actionLabel,
    VoidCallback? onPressAction,
  }) {
    if (!mounted) return;
    ScaffoldMessenger.of(this).hideCurrentSnackBar();
    ScaffoldMessenger.of(this).showSnackBar(getSnackBar(
        text: text, actionLabel: actionLabel, onPressAction: onPressAction));
  }
}

extension SnackbarStateExtension on ScaffoldMessengerState {
  void showSnackbar({
    String? text,
    String? actionLabel,
    VoidCallback? onPressAction,
  }) {
    showSnackBar(getSnackBar(
        text: text, actionLabel: actionLabel, onPressAction: onPressAction));
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
      backgroundColor: AppColors.snackBarBackground,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 2000),
      margin: EdgeInsets.only(bottom: 40.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      content: Text(
        text ?? '',
        style: AppTextStyle.textSm
            .addAll([AppTextStyle.textSm.leading5, AppTextStyle.bold]).copyWith(
                color: AppColors.white),
        textAlign: TextAlign.center,
      ),
      action: SnackBarAction(
        label: actionLabel,
        onPressed: () => onPressAction?.call(),
      ),
    );
  } else {
    snackBar = SnackBar(
      backgroundColor: AppColors.snackBarBackground,
      content: Text(
        text ?? '',
        style: AppTextStyle.textSm
            .addAll([AppTextStyle.textSm.leading5, AppTextStyle.bold]).copyWith(
                color: AppColors.white),
        textAlign: TextAlign.center,
      ),
      margin: EdgeInsets.symmetric(vertical: 40.h, horizontal: 16.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 2000),
    );
  }
  // Find the ScaffoldMessenger in the widget tree
  // and use it to show a SnackBar.
  return snackBar;
}
