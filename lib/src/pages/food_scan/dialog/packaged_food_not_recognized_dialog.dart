import 'package:flutter/material.dart';

import '../../../common/constant/app_constants.dart';
import '../widgets/packaged_food_not_recognized_widget.dart';

class PackagedFoodNotRecognizedDialog {
  PackagedFoodNotRecognizedDialog.show({
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
          child: PackagedFoodNotRecognizedWidget(
            onTapCancel: () => onTapCancel?.call(context),
            onTapScanNutritionFacts: () => onTapScanNutrition?.call(context),
          ),
        );
      },
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
