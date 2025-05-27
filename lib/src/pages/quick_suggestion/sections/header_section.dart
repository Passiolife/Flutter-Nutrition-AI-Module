import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/extension/core_extension.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({this.controller, super.key});
  final ScrollController? controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          8.verticalSpace,
          Container(
            width: 48.w,
            height: 5.h,
            decoration: BoxDecoration(
              color: AppColors.gray200,
              borderRadius: BorderRadius.circular(24.r),
            ),
          ),
          16.verticalSpace,
          Text(
            context.localization.quickSuggestions,
            style: AppTextStyle.textXl.addAll([
              AppTextStyle.textXl.leading7,
              AppTextStyle.bold
            ]).copyWith(color: AppColors.gray900),
          ),
          4.verticalSpace,
          Text(
            context.localization.quickSuggestionsDescription,
            style: AppTextStyle.textSm,
          ),
        ],
      ),
    );
  }
}
