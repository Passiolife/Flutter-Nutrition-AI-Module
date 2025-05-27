import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/extension/core_extension.dart';
import '../../../common/widgets/core_widgets.dart';

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({
    this.onCancel,
    this.onSave,
    this.saveLoading = false,
    super.key,
  });

  final VoidCallback? onCancel;
  final VoidCallback? onSave;
  final bool saveLoading;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: AppShadows.base,
        padding: AppPadding.pa16 + context.bottomPadding,
        child: Row(
          children: [
            Expanded(
              child: SecondaryButton(
                text: context.localization.cancel,
                onTap: onCancel,
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: PrimaryButton(
                text: context.localization.save,
                onTap: onSave,
                loading: saveLoading,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
