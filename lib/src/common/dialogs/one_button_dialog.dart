import 'package:flutter/material.dart';

import '../constant/app_constants.dart';
import '../widgets/adaptive_action_button_widget.dart';

class OneButtonDialog {
  OneButtonDialog.show({
    required BuildContext context,
    String? title,
    String? message,
    String? buttonText,
    Function(BuildContext context)? onTap,
  }) {
    showGeneralDialog(
      context: context,
      transitionDuration: const Duration(milliseconds: 250),
      barrierDismissible: false,
      transitionBuilder: (context, a1, a2, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(a1),
          child: child,
        );
      },
      pageBuilder: (context, animation, animation2) {
        return AlertDialog.adaptive(
          backgroundColor: AppColors.adaptiveDialogColor,
          surfaceTintColor: AppColors.adaptiveDialogColor,
          title: Text(
            title ?? '',
            style: AppTextStyle.textLg.addAll([AppTextStyle.semiBold]),
          ),
          content: Text(
            message ?? '',
            textAlign: TextAlign.center,
            style: AppTextStyle.textSm,
          ),
          actions: <Widget>[
            adaptiveAction(
              context: context,
              onPressed: () => onTap?.call(context),
              child: Text(
                buttonText ?? '',
                style: AppTextStyle.textLg
                    .copyWith(color: AppColors.indigo600Main),
              ),
            ),
          ],
        );
      },
    );
  }
}
