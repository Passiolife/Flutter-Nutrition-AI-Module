import 'package:flutter/material.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/app_button.dart';
import 'interfaces.dart';

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({
    this.cancelButtonText,
    this.logButtonText,
    this.listener,
    super.key,
  });

  final String? cancelButtonText;
  final String? logButtonText;
  final EditFoodListener? listener;

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
              onTap: () => listener?.onCancelTapped(),
            ),
          ),
          SizedBox(width: AppDimens.w16),
          Expanded(
            child: AppButton(
              buttonText: logButtonText ?? context.localization?.save,
              appButtonModel: AppButtonStyles.primary,
              onTap: () => listener?.onLogTapped(),
            ),
          ),
        ],
      ),
    );
  }
}
