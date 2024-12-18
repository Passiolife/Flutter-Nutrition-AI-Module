import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../../../../common/constant/app_constants.dart';
import '../../../../../../common/util/context_extension.dart';
import '../../../../../../common/util/double_extensions.dart';
import '../../bloc/recipe_creator_bloc.dart';

class ServingSizeTitleWidget extends StatelessWidget {
  const ServingSizeTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final servingSize = context.watch<RecipeCreatorBloc>().viewModel.foodRecord?.computedWeight;

    return RichText(
      text: TextSpan(
        text: context.localization?.servingSize,
        style: AppTextStyle.textBase.addAll(
            [AppTextStyle.textBase.leading6, AppTextStyle.semiBold]).copyWith(
          color: AppColors.gray900,
        ),
        children: [
          TextSpan(
            text:
                ' (${servingSize?.value.format(places: 0) ?? 0} ${servingSize?.symbol ?? 'g'})',
            style: AppTextStyle.textBase
                .addAll([AppTextStyle.textBase.leading6]).copyWith(
              color: AppColors.gray900,
            ),
          ),
        ],
      ),
    );
  }
}
