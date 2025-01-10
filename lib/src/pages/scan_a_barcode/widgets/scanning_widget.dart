import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/extension/context_extension.dart';

class ScanningWidget extends StatelessWidget {
  const ScanningWidget({this.onTap, super.key});
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.maxFinite,
          decoration: AppShadows.base,
          margin: AppPadding.ph16 + AppPadding.pv24,
          padding: AppPadding.pa8,
          child: Row(
            children: [
              SizedBox(
                width: AppDimens.r40,
                height: AppDimens.r40,
                child: const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.indigo600Main),
                ),
              ),
              SizedBox(width: AppDimens.w16),
              RichText(
                text: TextSpan(
                  text: '${context.localization.scanning ?? ''} \n',
                  style: AppTextStyle.textSm.addAll([
                    AppTextStyle.textSm.leading5,
                    AppTextStyle.semiBold
                  ]).copyWith(
                    color: AppColors.gray900,
                  ),
                  children: [
                    TextSpan(
                      text: context.localization.scanningDescription ?? '',
                      style: AppTextStyle.textSm.addAll([
                        AppTextStyle.textSm.leading5,
                      ]).copyWith(color: AppColors.gray500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Center(
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: context.localization.noBarcodeTakePicture ?? '',
                    style: AppTextStyle.textSm.addAll([
                      AppTextStyle.textSm.leading5,
                    ]),
                  ),
                  TextSpan(
                    text: context.localization.nutritionFacts ?? '',
                    recognizer: TapGestureRecognizer()..onTap = onTap,
                    style: AppTextStyle.textSm.addAll([
                      AppTextStyle.textSm.leading5,
                      AppTextStyle.bold,
                    ]).copyWith(color: context.theme.primaryColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        context.bottomPaddingValue.verticalSpace,
      ],
    );
  }
}
