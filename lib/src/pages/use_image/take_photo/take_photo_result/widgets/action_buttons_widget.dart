import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/constant/app_padding.dart';
import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/util/snackbar_extension.dart';
import '../../../../../common/widgets/button/primary_button.dart';
import '../../../../../common/widgets/button/secondary_button.dart';
import '../bloc/take_photo_result_bloc.dart';

class ActionButtonsWidget extends StatelessWidget {
  const ActionButtonsWidget({
    this.onTapCreateRecipe,
    this.createRecipeEnabled = false,
    this.logEnabled = false,
    this.onTapLogSelected,
    this.isLogLoading = false,
    super.key,
  });

  final bool createRecipeEnabled;
  final VoidCallback? onTapCreateRecipe;

  final bool logEnabled;
  final VoidCallback? onTapLogSelected;
  final bool isLogLoading;

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
              onTap: onTapCreateRecipe,
              text: context.localization.createRecipe,
              enabled: createRecipeEnabled,
            ),
          ),
          Expanded(
            child: PrimaryButton(
              padding: AppPadding.pv12,
              enabled: logEnabled,
              onTap: onTapLogSelected,
              text: context.localization.logSelected,
              loading: isLogLoading,
            ),
          ),
        ],
      ),
    );
  }
}
