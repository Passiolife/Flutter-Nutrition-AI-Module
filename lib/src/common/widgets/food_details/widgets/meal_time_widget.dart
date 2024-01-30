import 'package:flutter/material.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/dimens.dart';
import '../../../models/food_record/food_record.dart';
import '../../animated_tab_bar/segment_animation.dart';

typedef OnUpdateMealTime = Function(MealLabel label);

class MealTimeWidget extends StatelessWidget {
  const MealTimeWidget(
      {this.onUpdateMealTime, this.selectedMealLabel, super.key});

  final OnUpdateMealTime? onUpdateMealTime;
  final MealLabel? selectedMealLabel;

  // [mealLabels] contains all the [MealLabel] values.
  List<MealLabel> get mealLabels => MealLabel.values;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.passioInset,
      surfaceTintColor: AppColors.passioInset,
      margin: EdgeInsets.symmetric(horizontal: Dimens.w4),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.r26)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSegment(
            initialSegment: mealLabels
                .firstWhere(
                    (element) => element.value == selectedMealLabel?.value,
                    orElse: () => mealLabels.first)
                .index,
            segmentNames: mealLabels.map((e) => e.value).toList(),
            onSegmentChanged: (index) {
              onUpdateMealTime?.call(mealLabels.elementAt(index));
            },
            backgroundColor: AppColors.whiteColor,
            segmentTextColor: AppColors.bgColor,
            rippleEffectColor: AppColors.bgColor,
            selectedSegmentColor: AppColors.buttonColor,
          ),
        ],
      ),
    );
  }
}
