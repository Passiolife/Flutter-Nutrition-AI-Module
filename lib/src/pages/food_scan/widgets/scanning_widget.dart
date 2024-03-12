import 'package:flutter/material.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';

class ScanningWidget extends StatelessWidget {
  const ScanningWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: AppDimens.w24,
      top: AppDimens.h180 +
          AppDimens.h100 +
          AppDimens.h110 +
          AppDimens.h100 +
          AppDimens.h24,
      right: AppDimens.w24,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.slateGray75,
          borderRadius: BorderRadius.circular(AppDimens.r6),
        ),
        padding: EdgeInsets.all(AppDimens.r16),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: '${context.localization?.scanning ?? ''} \n',
            style: AppTextStyle.textSm.addAll(
                [AppTextStyle.textSm.leading5, AppTextStyle.bold]).copyWith(
              color: AppColors.white,
            ),
            children: [
              TextSpan(
                text: context.localization?.scanningDescription ?? '',
                style: AppTextStyle.textSm.addAll([
                  AppTextStyle.textSm.leading5,
                  AppTextStyle.medium
                ]).copyWith(color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
