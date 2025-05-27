import 'package:flutter/material.dart';

import '../constant/app_border.dart';
import '../constant/app_colors.dart';
import '../constant/app_dimens.dart';
import '../extension/context_extension.dart';

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
      shape:
          shape ?? RoundedRectangleBorder(borderRadius: AppBorderCircular.bt16),
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
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color? barrierColor,
    bool fullscreen = false,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: '',
      barrierColor: barrierColor ??
          AppColors.gray500.withValues(alpha: AppDimens.opacity75),
      pageBuilder: (context, anim1, anim2) => builder.call(context),
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

  static Future<T?> showCustomGeneralDialogNew<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color? barrierColor,
    bool fullscreen = false,
    VoidCallback? barrierDismissibleCallback,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: '',
      barrierColor: barrierColor ??
          AppColors.gray500.withValues(alpha: AppDimens.opacity75),
      pageBuilder: (context, anim1, anim2) => builder.call(context),
      transitionDuration: const Duration(milliseconds: AppDimens.duration250),
      transitionBuilder: (context, animation1, animation2, child) {
        return PopScope(
          canPop: false,
          child: SlideTransition(
            position: Tween(
              begin: const Offset(0, 1),
              end: const Offset(0, 0),
            ).animate(animation1),
            child: Material(
              color: Colors.transparent,
              child: fullscreen
                  ? child
                  : Stack(
                      children: [
                        // Full-screen GestureDetector to handle taps outside the dialog
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: () {
                              if (barrierDismissible) {
                                Navigator.of(context).pop();
                                barrierDismissibleCallback?.call();
                              }
                            },
                            behavior: HitTestBehavior.opaque,
                          ),
                        ),
                        SizedBox(
                          width: context.width,
                          child: Center(
                            child: Wrap(
                              children: [
                                GestureDetector(
                                  onTap: () {},
                                  behavior: HitTestBehavior.opaque,
                                  child: child,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
