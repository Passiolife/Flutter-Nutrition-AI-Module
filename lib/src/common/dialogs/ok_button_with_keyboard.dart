import 'package:flutter/material.dart';

import '../constant/app_button_styles.dart';
import '../constant/app_colors.dart';
import '../util/context_extension.dart';
import '../widgets/app_button.dart';

class OkButtonWithKeyboard {
  OverlayEntry? overlayEntry;

  OkButtonWithKeyboard.show(
      {required BuildContext context, VoidCallback? onTap}) {
    if (overlayEntry != null) return;

    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: SizedBox(
            width: double.infinity,
            child: Material(
              color: AppColors.transparent,
              child: AppButton(
                buttonText: context.localization?.ok,
                appButtonModel: AppButtonStyles.primary,
                onTap: onTap,
              ),
            ),
          ),
        );
      },
    );

    overlayState.insert(overlayEntry!);
  }

  void hide() {
    if (overlayEntry != null) {
      overlayEntry?.remove();
      overlayEntry = null;
    }
  }
}
