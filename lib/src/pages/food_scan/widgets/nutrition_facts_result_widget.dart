import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/action_buttons_widget.dart';

class NutritionFactsResultWidget extends StatelessWidget {
  const NutritionFactsResultWidget({this.nutritionFacts, super.key});

  final PassioNutritionFacts? nutritionFacts;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        16.verticalSpace,
        Text(
          context.localization?.nutritionFacts ?? '',
          style: AppTextStyle.textXl.addAll([
            AppTextStyle.textXl.leading7,
            AppTextStyle.bold
          ]).copyWith(color: AppColors.gray900),
        ),
        24.verticalSpace,
        Row(
          children: [
            Expanded(
              child: _RowItem(
                title: context.localization?.calories,
                value: nutritionFacts?.calories?.toString(),
              ),
            ),
            Expanded(
              child: _RowItem(
                title: context.localization?.carbs,
                value: nutritionFacts?.carbs?.toString(),
                valueUnit: 'g',
              ),
            ),
            Expanded(
              child: _RowItem(
                title: context.localization?.protein,
                value: nutritionFacts?.protein?.toString(),
                valueUnit: 'g',
              ),
            ),
            Expanded(
              child: _RowItem(
                title: context.localization?.fat,
                value: nutritionFacts?.fat?.toString(),
                valueUnit: 'g',
              ),
            ),
          ],
        ),
        24.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: ActionButtonsWidget(
            betweenSpace: 16,
            negativeButtonText: context.localization?.cancel ?? '',
            positiveButtonText: context.localization?.next,
          ),
        ),
      ],
    );
  }
}

class _RowItem extends StatelessWidget {
  const _RowItem({
    this.title,
    this.value,
    this.valueUnit,
  });

  final String? title;
  final String? value;
  final String? valueUnit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: value ?? '-',
            style: AppTextStyle.textLg.addAll([
              AppTextStyle.textLg.leading7,
              AppTextStyle.bold
            ]).copyWith(color: AppColors.indigo600Main),
            children: [
              TextSpan(
                text: valueUnit ?? '',
                style: AppTextStyle.textBase.copyWith(color: AppColors.gray500),
              ),
            ],
          ),
        ),
        4.verticalSpace,
        Text(
          title ?? '',
          style: AppTextStyle.textSm.addAll([
            AppTextStyle.textSm.leading4,
            AppTextStyle.medium
          ]).copyWith(color: AppColors.gray900),
        ),
      ],
    );
  }
}
