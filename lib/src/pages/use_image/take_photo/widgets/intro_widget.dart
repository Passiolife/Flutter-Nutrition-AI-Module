import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/util/context_extension.dart';
import '../../../../common/widgets/app_button.dart';

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
        child: Container(
          width: context.width,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          margin: EdgeInsets.symmetric(horizontal: 40.w),
          padding: EdgeInsets.symmetric(
            horizontal: AppDimens.w24,
            vertical: AppDimens.h16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.localization?.takePictureIntroTitle ?? '',
                style: AppTextStyle.textXl.addAll([
                  AppTextStyle.textXl.leading6,
                  AppTextStyle.bold
                ]).copyWith(color: AppColors.black),
              ),
              24.verticalSpace,
              Image.asset(
                AppImages.imgTakePictureIntro,
                width: 141.r,
                height: 141.r,
              ),
              24.verticalSpace,
              Text(
                context.localization?.takePictureIntroSubtitle ?? '',
                textAlign: TextAlign.center,
                style: AppTextStyle.textLg
                    .addAll([]).copyWith(color: AppColors.black),
              ),
              24.verticalSpace,
              IntrinsicWidth(
                child: AppButton(
                  onTap: onTap,
                  buttonText: context.localization?.ok,
                  appButtonModel: AppButtonStyles.primary.copyWith(
                    decoration: BoxDecoration(
                      color: AppButtonStyles.primary.decoration?.color,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 16.h, horizontal: 58.w),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
