import 'package:flutter/material.dart';

import '../../../common/constant/app_constants.dart';
import '../widgets/barcode_not_recognized_widget.dart';

class BarcodeNotRecognizedDialog {
  BarcodeNotRecognizedDialog.show({
    required BuildContext context,
    Function(BuildContext context)? onTapCancel,
    Function(BuildContext context)? onTapScanNutrition,
  }) {
    showGeneralDialog(
      context: context,
      barrierColor: AppColors.transparent,
      pageBuilder: (context, animation1, animation2) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: BarcodeNotRecognizedWidget(
            onTapCancel: () => onTapCancel?.call(context),
            onTapScanNutritionFacts: () => onTapScanNutrition?.call(context),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: AppDimens.duration400),
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
