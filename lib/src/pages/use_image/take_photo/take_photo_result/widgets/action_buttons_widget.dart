import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/constant/app_padding.dart';
import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/util/snackbar_extension.dart';
import '../../../../../common/widgets/button/primary_button.dart';
import '../../../../../common/widgets/button/secondary_button.dart';

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({
    this.onTapCreateRecipe,
    this.createRecipeEnabled = false,
    this.logEnabled = false,
    this.onTapLogSelected,
    super.key,
  });

  final bool createRecipeEnabled;
  final VoidCallback? onTapCreateRecipe;

  final bool logEnabled;
  final VoidCallback? onTapLogSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.pa16,
      child: Row(
        spacing: 16.w,
        children: [
          Expanded(
            child: SecondaryButton(
              padding: AppPadding.pv12,
              onTap: () {
              },
              text: context.localization.createRecipe,
              enabled: createRecipeEnabled,
            ),
          ),
          Expanded(
            child: PrimaryButton(
              padding: AppPadding.pv12,
              enabled: logEnabled,
              onTap: () {},
              text: context.localization.logSelected,
            ),
          ),
        ],
      ),
    );
  }
}
