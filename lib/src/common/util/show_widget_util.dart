import 'package:flutter/material.dart';

import '../constant/app_border.dart';
import '../constant/app_colors.dart';
import '../constant/app_dimens.dart';

class ShowWidgetUtil {
  const ShowWidgetUtil._();

  static Future<T?> showCustomModalBottomSheet<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool isScrollControlled = false,
    bool isDismissible = true,
    bool enableDrag = false,
    bool useRootNavigator = true,
    Color backgroundColor = AppColors.white,
    ShapeBorder? shape,
  }) {
    return showModalBottomSheet<T>(
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      isScrollControlled: isScrollControlled,
      shape: shape ?? RoundedRectangleBorder(borderRadius: AppBorderCircular.bt16),
      useRootNavigator: useRootNavigator,
      backgroundColor: backgroundColor,
      context: context,
      builder: builder,
    );
  }

  static Future<T?> showCustomDialog<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color barrierColor = AppColors.white,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      builder: builder,
    );
  }

  static Future<T?> showCustomGeneralDialog<T>({
    required BuildContext context,
    required RoutePageBuilder pageBuilder,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor ?? AppColors.gray500.withValues(alpha: AppDimens.opacity75),
      pageBuilder: pageBuilder,
      transitionDuration: const Duration(milliseconds: AppDimens.duration250),
      transitionBuilder: (context, animation1, animation2, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(animation1),
          child: child,
        );
      },
    );
  }
}
