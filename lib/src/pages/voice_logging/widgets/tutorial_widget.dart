import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';

class TutorialWidget extends StatelessWidget {
  const TutorialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text.rich(
            TextSpan(
              text: context.localization?.tap,
              style: AppTextStyle.textLg
                  .addAll([AppTextStyle.textLg.leading6]).copyWith(
                      color: AppColors.gray900),
              children: [
                WidgetSpan(
                  child: SizedBox(
                    width: 4.w,
                  ),
                ),
                TextSpan(
                  text: '${context.localization?.startListening},',
                  style: AppTextStyle.textLg.addAll([
                    AppTextStyle.textLg.leading6,
                    AppTextStyle.semiBold
                  ]).copyWith(color: AppColors.gray900),
                ),
                WidgetSpan(
                  child: SizedBox(
                    width: 4.w,
                  ),
                ),
                TextSpan(
                  text: context.localization?.thenSaySomethingLike,
                  style: AppTextStyle.textLg
                      .addAll([AppTextStyle.textLg.leading6]).copyWith(
                          color: AppColors.gray900),
                ),
              ],
            ),
          ),
          16.verticalSpace,
          Text(
            context.localization?.voiceLoggingExample ?? '',
            textAlign: TextAlign.center,
            style: AppTextStyle.textLg.addAll([
              AppTextStyle.textLg.leading8,
              AppTextStyle.medium,
              AppTextStyle.italic,
            ]),
          ),
        ],
      ),
    );
  }
}
