import 'package:flutter/material.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/app_button.dart';
import '../../../common/widgets/app_text_field.dart';

class ScannedNutritionFactsWidget extends StatelessWidget {
  const ScannedNutritionFactsWidget({
    this.servingSizeValue,
    this.caloriesValue,
    this.carbsValue,
    this.proteinValue,
    this.fatValue,
    this.onTapCancel,
    this.onTapNext,
    super.key,
  });

  final String? servingSizeValue;
  final String? caloriesValue;
  final String? carbsValue;
  final String? proteinValue;
  final String? fatValue;
  final VoidCallback? onTapCancel;
  final VoidCallback? onTapNext;

  List<({String? label, String? value})> scannedNutritionFacts(
          BuildContext context) =>
      [
        (label: context.localization?.servingSize, value: servingSizeValue),
        (label: context.localization?.calories, value: caloriesValue),
        (label: context.localization?.carbs, value: carbsValue),
        (label: context.localization?.protein, value: proteinValue),
        (label: context.localization?.fat, value: fatValue),
      ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      surfaceTintColor: AppColors.transparent,
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.w16),
          child: Container(
            width: context.width,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppDimens.r16),
            ),
            padding: EdgeInsets.all(AppDimens.r16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.localization?.scannedNutritionFacts ?? '',
                  style: AppTextStyle.textLg.addAll([
                    AppTextStyle.textLg.leading6,
                    AppTextStyle.semiBold
                  ]).copyWith(color: AppColors.gray900),
                ),
                SizedBox(height: AppDimens.h8),
                Text(
                  context.localization?.scannedNutritionFactsDescription ?? '',
                  style: AppTextStyle.textSm,
                ),
                SizedBox(height: AppDimens.h16),
                ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (BuildContext context, int index) {
                    final data =
                        scannedNutritionFacts(context).elementAt(index);
                    return _ScannedNutritionFactsRow(
                      label: data.label,
                      value: data.value,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(color: AppColors.gray200);
                  },
                  itemCount: scannedNutritionFacts(context).length,
                ),
                SizedBox(height: AppDimens.h16),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        buttonText: context.localization?.cancel,
                        appButtonModel: AppButtonStyles.primaryCustomBordered,
                        onTap: onTapCancel,
                      ),
                    ),
                    SizedBox(width: AppDimens.w8),
                    Expanded(
                      child: AppButton(
                        buttonText: context.localization?.next,
                        appButtonModel: AppButtonStyles.primaryCustom,
                        onTap: onTapNext,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ScannedNutritionFactsRow extends StatelessWidget {
  const _ScannedNutritionFactsRow({this.label, this.value});

  final String? label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppDimens.h4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label ?? '',
              style: AppTextStyle.textSm.addAll([
                AppTextStyle.textSm.leading5,
                AppTextStyle.medium
              ]).copyWith(color: AppColors.gray500),
            ),
          ),
          const Flexible(
            child: AppTextField(),
          ),
          /*Container(
            width: AppDimens.w120,
            height: AppDimens.h42,
            decoration: AppShadows.sm
                .copyWith(border: Border.all(color: AppColors.gray300)),
            padding: EdgeInsets.only(left: AppDimens.w12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                value ?? '',
                style: AppTextStyle.textBase.copyWith(color: AppColors.gray900),
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}
