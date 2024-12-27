import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/constant/app_button_styles.dart';
import '../../../../../../common/extension/context_extension.dart';
import '../../../../../../common/widgets/app_button.dart';
import '../../bloc/recipe_creator_bloc.dart';

class ActionButtonsSection extends StatelessWidget {
  const ActionButtonsSection({super.key});

  @override
  Widget build(BuildContext context) {
    bool validate = context.watch<RecipeCreatorBloc>().viewModel.validate;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: AppButton(
              onTap: () {
                Navigator.of(context).pop();
              },
              buttonText: context.localization?.cancel,
              appButtonModel: AppButtonStyles.primaryBordered,
            ),
          ),
          16.horizontalSpace,
          Expanded(
            child: AppButton(
              isEnable: validate,
              onTap: () {
                context.read<RecipeCreatorBloc>().add(const SaveRecipeEvent());
              },
              buttonText: context.localization?.save,
              appButtonModel: AppButtonStyles.primary,
            ),
          ),
        ],
      ),
    );
  }
}
