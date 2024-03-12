import 'package:flutter/material.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/app_button.dart';

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({
    this.cancelButtonText,
    this.logButtonText,
    this.onTapCancel,
    this.onTapLog,
    super.key,
  });

  final String? cancelButtonText;
  final String? logButtonText;
  final VoidCallback? onTapCancel;
  final VoidCallback? onTapLog;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.w16,
        vertical: AppDimens.h16,
      ),
      child: Row(
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
              buttonText: logButtonText ?? context.localization?.log,
              appButtonModel: AppButtonStyles.primary,
              onTap: onTapLog,
            ),
          ),
        ],
      ),
    );
  }
}
