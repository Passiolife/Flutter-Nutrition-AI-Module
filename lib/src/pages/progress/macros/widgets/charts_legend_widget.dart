import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/util/context_extension.dart';

class ChartsLegendWidget extends StatelessWidget {
  const ChartsLegendWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _LengendItemWidget(
          color: AppColors.yellow500,
          text: context.localization?.calories,
        ),
        32.horizontalSpace,
        _LengendItemWidget(
          color: AppColors.green500Normal,
          text: context.localization?.protein,
        ),
        32.horizontalSpace,
        _LengendItemWidget(
          color: AppColors.purple500,
          text: context.localization?.fat,
        ),
        32.horizontalSpace,
        _LengendItemWidget(
          color: AppColors.lBlue500Normal,
          text: context.localization?.carbs,
        ),
      ],
    );
  }
}

class _LengendItemWidget extends StatelessWidget {
  final Color color;
  final String? text;

  const _LengendItemWidget({required this.color, this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: color,
          radius: 6.r,
        ),
        8.horizontalSpace,
        Text(
          text ?? '',
          style: AppTextStyle.textSm,
        ),
      ],
    );
  }
}
