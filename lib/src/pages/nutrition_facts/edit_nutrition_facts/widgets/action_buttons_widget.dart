import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/extension/context_extension.dart';
import '../../../../common/widgets/core_widgets.dart';

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({
    this.onCancel,
    this.onSave,
    super.key,
  });

  final VoidCallback? onCancel;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16.w,
      children: [
        Expanded(
          child: SecondaryButton(
            text: context.localization.cancel,
            onTap: onCancel,
          ),
        ),
        Expanded(
          child: PrimaryButton(
            text: context.localization.saveAndLog,
            onTap: onSave,
          ),
        ),
      ],
    );
  }
}
