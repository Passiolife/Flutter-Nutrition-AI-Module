import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../common/constant/app_constants.dart';
import '../../../../../../common/util/context_extension.dart';

class TutorialWidget extends StatelessWidget {
  const TutorialWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(24.r),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        color: AppColors.tutorialBackgroundColor,
      ),
      child: Column(
        children: [
          Text(
            context.localization?.scanning ?? '',
            style: AppTextStyle.textSm
                .addAll([AppTextStyle.textSm.leading5, AppTextStyle.bold]),
            textAlign: TextAlign.center,
          ),
          Text(
            context.localization?.barcodeScannerDescription ?? '',
            style: AppTextStyle.textSm
                .addAll([AppTextStyle.textSm.leading5, AppTextStyle.medium]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
