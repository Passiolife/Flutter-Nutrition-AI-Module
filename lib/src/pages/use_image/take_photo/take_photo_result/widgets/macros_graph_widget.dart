import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/constant/app_padding.dart';
import '../../../../../common/models/daily_nutrition_model.dart';
import '../../../../../common/widgets/percent_indicator/percent_indicator.dart';

class MacrosGraphWidget extends StatelessWidget {
  const MacrosGraphWidget({
    required this.listNutrition,
    super.key,
  });

  final List<DailyNutritionModel> listNutrition;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppPadding.ph16 + AppPadding.pb8 + AppPadding.pt8,
      child: Row(
        spacing: 16.w,
        children: listNutrition
            .map(
              (data) => Expanded(
            child: PercentIndicator.circular(
              size: 40.r,
              percentValue: data.value,
              title: data.title,
              subtitle: data.subtitle,
              backgroundColor: data.backgroundColor,
              progressColor: data.progressColor,
              footer: data.footer,
            ),
          ),
        )
            .toList(),
      ),
    );
  }
}
