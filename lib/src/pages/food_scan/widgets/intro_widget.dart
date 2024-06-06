import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/app_button.dart';

class IntroWidget extends StatelessWidget {
  const IntroWidget({this.onTap, super.key});

  final VoidCallback? onTap;

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
              borderRadius: BorderRadius.circular(AppDimens.r20),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: AppDimens.w20,
              vertical: AppDimens.h16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.localization?.foodScanIntroTitle ?? '',
                  style: AppTextStyle.textXl.addAll([
                    AppTextStyle.textXl.leading6,
                    AppTextStyle.bold
                  ]).copyWith(color: AppColors.black),
                ),
                SizedBox(height: AppDimens.h4),
                Text(
                  context.localization?.foodScanIntroDescription ?? '',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.textSm
                      .addAll([]).copyWith(color: AppColors.black),
                ),
                SizedBox(height: AppDimens.h16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _FoodsVarietyWidget(
                      imagePath: AppImages.icFoods,
                      text: context.localization?.foods,
                    ),
                    _FoodsVarietyWidget(
                      imagePath: AppImages.icBeverages,
                      text: context.localization?.beverages,
                    ),
                    _FoodsVarietyWidget(
                      imagePath: AppImages.icPackaging,
                      text: context.localization?.packaging,
                    ),
                    _FoodsVarietyWidget(
                      imagePath: AppImages.icNutritionFacts,
                      text: context.localization?.nutritionFacts,
                    ),
                    _FoodsVarietyWidget(
                      imagePath: AppImages.icBarcodes,
                      text: context.localization?.barcodes,
                    ),
                  ],
                ),
                SizedBox(height: AppDimens.h32),
                AppButton(
                  onTap: onTap,
                  buttonText: context.localization?.ok,
                  appButtonModel: AppButtonStyles.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FoodsVarietyWidget extends StatelessWidget {
  const _FoodsVarietyWidget({required this.imagePath, this.text});

  final String imagePath;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          imagePath,
          width: AppDimens.r40,
          height: AppDimens.r40,
        ),
        Text(
          text ?? '',
          style: AppTextStyle.textXs.copyWith(color: AppColors.black),
        ),
      ],
    );
  }
}
