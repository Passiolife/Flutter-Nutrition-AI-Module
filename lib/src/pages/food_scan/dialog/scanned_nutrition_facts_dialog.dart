import 'dart:developer';

import 'package:flutter/material.dart';

import '../../../common/constant/app_dimens.dart';
import '../../../common/dialogs/single_text_field_dialog.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/string_extensions.dart';
import '../widgets/scanned_nutrition_facts_widget.dart';

class ScannedNutritionFactsDialog {
  ScannedNutritionFactsDialog.show({
    required BuildContext context,
  }) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return ScannedNutritionFactsWidget(
          servingSizeValue: '6 oz (170 g)',
          caloriesValue: '150',
          carbsValue: '27 g',
          proteinValue: '6 g',
          fatValue: '1 g',
          onTapCancel: () => Navigator.pop(context),
          onTapNext: () {
            SingleTextFieldDialog.show(
              context: context,
              title: context.localization?.nameYourFood,
              description: context.localization?.nameYourFoodDescription,
              placeHolder: context.localization?.enterAName,
              validationBuilder: (text) {
                if (text.isNotNullOrEmpty) {
                  return null;
                }
                return context.localization?.pleaseEnterAName;
              },
              onSave: (text) {
                log(text);
              },
            );
          },
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
