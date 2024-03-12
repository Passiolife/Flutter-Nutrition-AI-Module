import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/constant/app_colors.dart';
import '../../common/constant/app_dimens.dart';
import '../../common/constant/app_images.dart';
import '../../common/constant/app_shadow.dart';
import '../../common/constant/app_text_styles.dart';
import '../../common/util/context_extension.dart';
import '../../common/widgets/macros_graph_widget.dart';

class DailyNutritionWidget extends StatelessWidget {
  const DailyNutritionWidget({
    this.consumedCalories,
    this.totalCalories,
    this.consumedCarbs,
    this.totalCarbs,
    this.consumedProteins,
    this.totalProteins,
    this.consumedFat,
    this.totalFat,
    super.key,
  });

  // Calories
  final double? consumedCalories;
  final double? totalCalories;

  // Carbs
  final double? consumedCarbs;
  final double? totalCarbs;

  // Proteins
  final double? consumedProteins;
  final double? totalProteins;

  // Fat
  final double? consumedFat;
  final double? totalFat;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: AppShadows.base,
      padding: EdgeInsets.all(AppDimens.r16),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                AppImages.icFluentFoodAppleFilled,
                fit: BoxFit.cover,
                width: AppDimens.r24,
                height: AppDimens.r24,
              ),
              SizedBox(width: AppDimens.w8),
              Expanded(
                child: Text(
                  context.localization?.dailyNutrition ?? '',
                  style: AppTextStyle.textLg.addAll([
                    AppTextStyle.textLg.leading6,
                    AppTextStyle.semiBold
                  ]).copyWith(color: AppColors.gray900),
                ),
              ),
              /*SvgPicture.asset(
                AppImages.icExternalLink,
                width: AppDimens.r24,
                height: AppDimens.r24,
              ),*/
            ],
          ),
          SizedBox(height: AppDimens.h24),
          MacrosGraphWidget(
            consumedCalories: consumedCalories ?? 0,
            totalCalories: totalCalories ?? 1200,
            consumedCarbs: consumedCarbs ?? 0,
            totalCarbs: totalCarbs ?? 150,
            consumedProteins: consumedProteins ?? 0,
            totalProteins: totalProteins ?? 90,
            consumedFat: consumedFat ?? 0,
            totalFat: totalFat ?? 27,
          ),
        ],
      ),
    );
  }
}
