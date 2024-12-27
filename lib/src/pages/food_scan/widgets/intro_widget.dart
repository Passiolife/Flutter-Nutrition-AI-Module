import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/extension/context_extension.dart';
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
              borderRadius: BorderRadius.circular(16.r),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
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
                SizedBox(height: 4.h),
                Text(
                  context.localization?.foodScanIntroDescription ?? '',
                  textAlign: TextAlign.center,
                  style: AppTextStyle.textSm
                      .addAll([]).copyWith(color: AppColors.black),
                ),
                SizedBox(height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _FoodsVarietyWidget(
                      imagePath: AppImages.icFoods,
                      text: context.localization?.wholeFoodsMode,
                    ),
                    _FoodsVarietyWidget(
                      imagePath: AppImages.icBarcodes,
                      text: context.localization?.barcodeMode,
                    ),
                    _FoodsVarietyWidget(
                      imagePath: AppImages.icNutritionFacts,
                      text: context.localization?.nutritionFactsMode,
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
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
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: AppColors.indigo600Main,
            child: Padding(
              padding: EdgeInsets.all(8.r),
              child: SvgPicture.asset(
                imagePath,
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          Text(
            text ?? '',
            style: AppTextStyle.textXs.copyWith(color: AppColors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
