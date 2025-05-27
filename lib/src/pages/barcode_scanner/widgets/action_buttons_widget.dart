import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_padding.dart';
import '../../../common/extension/context_extension.dart';
import '../../../common/widgets/button/primary_button.dart';
import '../../../common/widgets/button/secondary_button.dart';

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({
    required this.neutralButtonText,
    this.negativeButtonText,
    this.onNegativeButtonTap,
    this.positiveButtonText,
    this.onPositiveButtonTap,
    this.onNeutralButtonTap,
    super.key,
  });

  final String? negativeButtonText;
  final VoidCallback? onNegativeButtonTap;

  final String? positiveButtonText;
  final VoidCallback? onPositiveButtonTap;

  final String neutralButtonText;
  final VoidCallback? onNeutralButtonTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        /*Expanded(
          child: SecondaryButton(
            text: context.localization.cancel,
            onTap: () {
              Navigator.pop(context);
              onNegativeButtonTap?.call();
            },
            padding: AppPadding.pv12,
          ),
        ),
        16.horizontalSpace,*/
        Expanded(
          child: PrimaryButton(
            text: positiveButtonText ?? context.localization.useExistingItem,
            onTap: () {
              Navigator.pop(context);
              onPositiveButtonTap?.call();
            },
            padding: AppPadding.pv12,
          ),
        ),
        16.horizontalSpace,
        Expanded(
          child: SecondaryButton(
            text: neutralButtonText,
            onTap: () {
              Navigator.pop(context);
              onNeutralButtonTap?.call();
            },
            padding: AppPadding.pv12,
          ),
        ),
      ],
    );
  }
}
