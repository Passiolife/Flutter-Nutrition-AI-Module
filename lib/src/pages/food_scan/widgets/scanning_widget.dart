import 'package:flutter/material.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';

class ScanningWidget extends StatelessWidget {
  const ScanningWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
            left: AppDimens.r16, top: AppDimens.r24, right: AppDimens.r16),
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
                text: '${context.localization?.scanning ?? ''} \n',
                style: AppTextStyle.textSm.addAll([
                  AppTextStyle.textSm.leading5,
                  AppTextStyle.semiBold
                ]).copyWith(
                  color: AppColors.gray900,
                ),
                children: [
                  TextSpan(
                    text: context.localization?.scanningDescription ?? '',
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
    );
  }
}
