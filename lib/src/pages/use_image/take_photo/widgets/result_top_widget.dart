import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/extension/context_extension.dart';

class ResultTopWidget extends StatelessWidget {
  const ResultTopWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      child: Column(
        children: [
          (context.topPadding + 48).verticalSpace,
          AppBar(
            title: Text(
              context.localization?.yourResults ?? '',
              style: AppTextStyle.text2xl.addAll([
                AppTextStyle.text2xl.leading8,
                AppTextStyle.extraBold
              ]).copyWith(
                color: AppColors.gray900,
              ),
            ),
            centerTitle: true,
          ),
          16.verticalSpace,
        ],
      ),
    );
  }
}

class _MealTime extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Text(
        //   context.localization?.mealTime ?? '',
        //   style: AppTextStyle.textSm
        //       .addAll([AppTextStyle.textSm.leading5, AppTextStyle.medium]).copyWith(color: ),
        // ),
      ],
    );
  }
}
