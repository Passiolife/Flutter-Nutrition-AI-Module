import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant/app_constants.dart';
import '../util/context_extension.dart';
import '../util/string_extensions.dart';
import '../widgets/adaptive_action_button_widget.dart';

class SingleTextFieldDialog {
  SingleTextFieldDialog.show({
    required BuildContext context,
    String? title,
    String? description,
    String? placeHolder,
    Function(String text)? onSave,
    String? Function(String text)? validationBuilder,
  }) {
    final TextEditingController controller = TextEditingController();

    String? validationMessage;

    showAdaptiveDialog<String>(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog.adaptive(
            title: title != null
                ? Text(
                    title,
                    style: AppTextStyle.textLg.addAll([AppTextStyle.semiBold]),
                  )
                : null,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (description?.isNotEmpty ?? false)
                    ? Center(
                        child: Text(
                          description ?? '',
                          textAlign: TextAlign.center,
                          style: AppTextStyle.textSm,
                        ),
                      )
                    : const SizedBox.shrink(),
                SizedBox(height: AppDimens.h16),
                CupertinoTextField(
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  controller: controller,
                  placeholder: placeHolder,
                  clearButtonMode: OverlayVisibilityMode.editing,
                ),
                validationMessage != null
                    ? Padding(
                        padding: EdgeInsets.only(top: AppDimens.h2),
                        child: Text(
                          validationMessage ?? '',
                          style: AppTextStyle.textSm
                              .copyWith(color: AppColors.red600Error),
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
            actions: <Widget>[
              adaptiveAction(
                context: context,
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
                child: Text(
                  context.localization?.cancel?.toUpperCaseWord ?? '',
                  style: AppTextStyle.textLg
                      .copyWith(color: AppColors.indigo600Main),
                ),
              ),
              adaptiveAction(
                context: context,
                onPressed: () {
                  validationMessage = validationBuilder?.call(controller.text);
                  if (validationMessage != null) {
                    setState(() {});
                    return;
                  }
                  onSave?.call(controller.text);
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text(
                  context.localization?.save.toUpperCaseWord ?? '',
                  style: AppTextStyle.textLg
                      .copyWith(color: AppColors.indigo600Main),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
