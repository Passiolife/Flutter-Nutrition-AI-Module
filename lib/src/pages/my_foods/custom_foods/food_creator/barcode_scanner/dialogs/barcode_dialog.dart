import 'package:flutter/material.dart';

import '../../../../../../common/constant/app_colors.dart';
import '../widgets/barcode_widget.dart';

class BarcodeDialog {
  BarcodeDialog.show({
    required BuildContext context,
    String? title,
    String? description,
    Function(BuildContext context)? onTapCancel,
    Function(BuildContext context)? onViewExistingItem,
    String? customFoodButtonText,
    Function(BuildContext dContext)? onCreateCustomFood,
  }) {
    showGeneralDialog(
      context: context,
      barrierColor: AppColors.transparent,
      pageBuilder: (dContext, animation1, animation2) {
        return Align(
          alignment: Alignment.center,
          child: BarcodeWidget(
            title: title,
            description: description,
            onTapCancel: () => onTapCancel?.call(dContext),
            onViewExistingItem: () => onViewExistingItem?.call(dContext),
            customFoodButtonText: customFoodButtonText,
            onCreateCustomFood: () => onCreateCustomFood?.call(dContext),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
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
