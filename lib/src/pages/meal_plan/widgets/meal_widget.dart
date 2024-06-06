import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/double_extensions.dart';
import '../../../common/util/string_extensions.dart';
import '../../../common/widgets/app_loading_button_widget.dart';
import '../../../common/widgets/food_item_row_widget.dart';

abstract interface class MealListener {
  void onTappedLogEntireMeal(
      List<PassioFoodDataInfo>? listOfPassioFoodData, PassioMealTime? mealTime);

  void onTappedMealItem(
      PassioFoodDataInfo? passioFoodDataInfo, PassioMealTime? mealTime);

  void onTappedAdd(
      PassioFoodDataInfo? passioFoodDataInfo, PassioMealTime? mealTime);
}

class MealWidget extends StatelessWidget {
  const MealWidget({
    this.title,
    this.mealTime,
    this.listOfFoodData,
    this.listener,
    this.isLoading = false,
    this.isLogMealLoading = false,
    super.key,
  });

  final String? title;
  final PassioMealTime? mealTime;
  final List<PassioFoodDataInfo>? listOfFoodData;
  final MealListener? listener;
  final bool isLoading;
  final bool isLogMealLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title ?? '',
                    style: AppTextStyle.textBase.addAll([
                      AppTextStyle.textBase.leading6,
                      AppTextStyle.semiBold
                    ]),
                  ),
                ),
                isLogMealLoading
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        child: const AppLoadingButtonWidget(),
                      )
                    : GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: isLoading
                            ? null
                            : () => listener?.onTappedLogEntireMeal(
                                listOfFoodData, mealTime),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: Text(
                            context.localization?.logEntireMeal ?? '',
                            style: AppTextStyle.textSm.addAll([
                              AppTextStyle.textSm.leading5,
                              AppTextStyle.medium
                            ]).copyWith(color: AppColors.indigo600Main),
                          ),
                        ),
                      )
              ],
            ),
          ),
          const Divider(color: AppColors.gray200),
          8.verticalSpace,
          ListView.separated(
            itemCount: isLoading ? 2 : listOfFoodData?.length ?? 0,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final data = isLoading ? null : listOfFoodData?.elementAt(index);
              return FoodItemRowWidget(
                isLoading: isLoading,
                index: index,
                iconId: data?.iconID,
                title: data?.foodName.toUpperCaseWord,
                subtitle:
                    '${data?.nutritionPreview.servingQuantity.format() ?? ''} ${data?.nutritionPreview.servingUnit.toUpperCaseWord ?? ''} (${data?.nutritionPreview.weightQuantity.format()} ${data?.nutritionPreview.weightUnit}) | ${data?.nutritionPreview.calories ?? 0} ${context.localization?.cal.toUpperCaseWord ?? ''}',
                onTap: () => listener?.onTappedMealItem(data, mealTime),
                onTapAdd: () => listener?.onTappedAdd(data, mealTime),
              );
            },
            separatorBuilder: (context, index) {
              return 16.verticalSpace;
            },
          ),
          16.verticalSpace,
        ],
      ),
    );
  }
}
