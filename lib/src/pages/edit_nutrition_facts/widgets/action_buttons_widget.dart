import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/extension/context_extension.dart';
import '../../../common/widgets/core_widgets.dart';

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({
    this.positiveText,
    this.onCancel,
    this.onPositiveTap,
    super.key,
  });

  final String? positiveText;
  final VoidCallback? onPositiveTap;

  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16.w,
      children: [
        Expanded(
          child: SecondaryButton(
            text: context.localization.cancel,
            onTap: onCancel,
            padding: AppPadding.pv12,
          ),
        ),
        Expanded(
          child: PrimaryButton(
            text: positiveText,
            onTap: onPositiveTap,
            padding: AppPadding.pv12,
          ),
        ),
      ],
    );
  }
}
