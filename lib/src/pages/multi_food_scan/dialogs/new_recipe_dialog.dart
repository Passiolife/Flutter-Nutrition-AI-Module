import 'package:flutter/material.dart';
import '../../../common/constant/app_colors.dart';
import '../../../common/constant/styles.dart';

import '../../../common/util/context_extension.dart';
import '../../../common/util/string_extensions.dart';
import '../../../common/widgets/adaptive_action_button_widget.dart';

typedef OnSave = Function(String text);

class NewRecipeDialog {
  NewRecipeDialog.show({required BuildContext context, required String text, OnSave? onSave}) {
    TextEditingController controller = TextEditingController(text: text);
    final formKey = GlobalKey<FormState>();
    showAdaptiveDialog<String>(
      context: context,
      builder: (dialogContext) => AlertDialog.adaptive(
        title: Text(context.localization?.newRecipeTitle ?? ''),
        content: Material(
          type: MaterialType.transparency,
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: TextFormField(
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              controller: controller,
              decoration: InputDecoration(
                hintText: context.localization?.newRecipeHint ?? '',
                hintStyle: AppStyles.style14.copyWith(color: AppColors.hintColor),
                filled: true,
                fillColor: AppColors.passioInset,
                border: InputBorder.none,
                isDense: true
              ),
              validator: (value) {
                if (value.isNullOrEmpty) {
                  return context.localization?.recipeNameErrorMessage ?? '';
                }
                return null;
              },
            ),
          ),
        ),
        actions: <Widget>[
          adaptiveAction(
            context: context,
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.localization?.cancel.toUpperCaseWord ?? ''),
          ),
          adaptiveAction(
            context: context,
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                onSave?.call(controller.text);
                Navigator.pop(dialogContext);
              }
            },
            child: Text(context.localization?.save.toUpperCaseWord ?? ''),
          ),
        ],
      ),
    );
  }
}
