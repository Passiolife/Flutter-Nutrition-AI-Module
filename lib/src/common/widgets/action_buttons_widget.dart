import 'package:flutter/material.dart';

import '../constant/app_constants.dart';
import '../util/context_extension.dart';
import 'app_button.dart';

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({
    this.cancelButtonText,
    this.saveButtonText,
    this.onTapCancel,
    this.onTapSave,
    super.key,
  });

  final String? cancelButtonText;
  final String? saveButtonText;
  final VoidCallback? onTapCancel;
  final VoidCallback? onTapSave;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppButton(
            buttonText: cancelButtonText ?? context.localization?.cancel,
            appButtonModel: AppButtonStyles.primaryBordered,
            onTap: onTapCancel,
          ),
        ),
        SizedBox(width: AppDimens.w16),
        Expanded(
          child: AppButton(
            buttonText: saveButtonText ?? context.localization?.save,
            appButtonModel: AppButtonStyles.primary,
            onTap: onTapSave,
          ),
        ),
      ],
    );
  }
}
