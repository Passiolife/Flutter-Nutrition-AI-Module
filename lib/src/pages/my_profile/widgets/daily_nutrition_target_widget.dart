import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/models/chart_model/chart_data_model.dart';
import '../../../common/models/user_profile/user_profile_model.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/nutritional_graph_widget.dart';
import '../dialogs/daily_nutrition_target_dialog.dart';

class DailyNutritionWidgetWidget extends StatelessWidget {
  const DailyNutritionWidgetWidget({
    this.calories = 0,
    this.carbs = 0,
    this.carbsGrams = 0,
    this.proteins = 0,
    this.proteinGrams = 0,
    this.fat = 0,
    this.fatGrams = 0,
    this.profileModel,
    this.onSave,
    super.key,
  });

  final int calories;

  final int carbs;
  final int carbsGrams;

  final int proteins;
  final int proteinGrams;

  final int fat;
  final int fatGrams;

  final UserProfileModel? profileModel;
  final OnSaveNutritionTarget? onSave;

  List<ChartDataModel>? get chartData => [
        ChartDataModel(
          y: fat.toDouble(),
          color: fat > 0 ? AppColors.purple500 : AppColors.transparent,
        ),
        ChartDataModel(
          y: proteins.toDouble(),
          color:
              proteins > 0 ? AppColors.green500Normal : AppColors.transparent,
        ),
        ChartDataModel(
          y: carbs.toDouble(),
          color: carbs > 0 ? AppColors.lBlue500Normal : AppColors.transparent,
        ),
        ChartDataModel(
          y: fat <= 0 && proteins <= 0 && carbs <= 0 ? 100 : 0,
          color: AppColors.gray200,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColors.blue50,
      highlightColor: AppColors.blue50,
      onTap: () => DailyNutritionTargetDialog.show(
        context: context,
        profileModel: profileModel,
        onSave: onSave
      ),
      child: Container(
        decoration: AppShadows.base,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: 16.w),
                Expanded(
                  child: Text(
                    context.localization?.dailyNutritionTarget ?? '',
                    style: AppTextStyle.textBase.addAll([
                      AppTextStyle.textBase.leading6,
                      AppTextStyle.semiBold
                    ]),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(
                    AppImages.icExternalLink,
                    width: 24.r,
                    height: 24.r,
                  ),
                ),
              ],
            ),
            16.verticalSpace,
            NutritionalGraphWidget(
              key: ValueKey('$calories-$carbs-$proteins-$fat'),
              calories: calories.toDouble(),
              carbs: carbsGrams.toDouble(),
              carbsPercentage: carbs.toDouble(),
              proteins: proteinGrams.toDouble(),
              proteinsPercentage: proteins.toDouble(),
              fat: fatGrams.toDouble(),
              fatPercentage: fat.toDouble(),
              chartData: chartData,
            ),
            16.verticalSpace,
          ],
        ),
      ),
    );
  }
}
