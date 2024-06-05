import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/string_extensions.dart';
import '../../../common/widgets/adaptive_action_button_widget.dart';

typedef OnCreateRecipe = Function(String text);

class CreateRecipeDialog {
  CreateRecipeDialog.show({
    required BuildContext context,
    String? placeHolder,
    OnCreateRecipe? onCreateRecipe,
  }) {
    TextEditingController controller = TextEditingController();
    showAdaptiveDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog.adaptive(
        backgroundColor: (Platform.isAndroid) ? AppColors.blue50 : null,
        surfaceTintColor: (Platform.isAndroid) ? AppColors.blue50 : null,
        title: Text(context.localization?.createRecipe ?? ''),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.localization?.createRecipeDescription ?? '',
              textAlign: TextAlign.center,
              style: AppTextStyle.textSm,
            ),
            SizedBox(height: AppDimens.h16),
            CupertinoTextField(
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              controller: controller,
              clearButtonMode: OverlayVisibilityMode.editing,
              placeholder: placeHolder,
            ),
          ],
        ),
        actions: <Widget>[
          adaptiveAction(
            context: context,
            onPressed: () => Navigator.pop(context),
            child: Text(context.localization?.cancel?.toUpperCaseWord ?? ''),
          ),
          adaptiveAction(
            context: context,
            onPressed: () {
              String foodName;
              if (controller.text.isNotEmpty) {
                foodName = controller.text;
              } else {
                foodName = placeHolder ?? '';
              }
              Navigator.pop(context);
              onCreateRecipe?.call(foodName);
            },
            child: Text(context.localization?.create?.toUpperCaseWord ?? ''),
          ),
        ],
      ),
    );
  }
}
