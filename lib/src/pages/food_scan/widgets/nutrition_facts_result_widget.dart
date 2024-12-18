import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/app_button.dart';

abstract interface class NutritionFactsHandler {
  void onNext();
  void onCancel();
}

class NutritionFactsResultWidget extends StatelessWidget {
  const NutritionFactsResultWidget({
    this.nutritionFacts,
    this.isLoadingNext = false,
    this.isEnableNext = false,
    this.handler,
    super.key,
  });

  final PassioNutritionFacts? nutritionFacts;
  final bool isLoadingNext;
  final bool isEnableNext;
  final NutritionFactsHandler? handler;

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
          child: Row(
            children: [
              Expanded(
                child: AppButton(
                  buttonText: context.localization?.cancel ?? '',
                  appButtonModel: AppButtonStyles.primaryBordered,
                  onTap: handler?.onCancel,
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: AppButton(
                  buttonText: context.localization?.next ?? '',
                  appButtonModel: AppButtonStyles.primary,
                  onTap: handler?.onNext,
                  isLoading: isLoadingNext,
                  isEnable: isEnableNext,
                ),
              ),
            ],
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
