import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/models/food_record/meal_label.dart';
import '../../../../common/util/context_extension.dart';
import '../../bloc/edit_food_bloc.dart';
import '../widgets/meal_time_widget.dart';

class MealTimeSection extends StatelessWidget {
  const MealTimeSection({
    required this.visibleMealTimeView,
    this.mealLabel,
    super.key,
  });

  final bool visibleMealTimeView;
  final MealLabel? mealLabel;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visibleMealTimeView,
      child: Container(
        decoration: AppShadows.base,
        padding: EdgeInsets.all(AppDimens.r16),
        margin: EdgeInsets.only(bottom: AppDimens.h16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.localization?.mealTime ?? '',
              style: AppTextStyle.textBase.addAll([
                AppTextStyle.textBase.leading6,
                AppTextStyle.semiBold
              ]).copyWith(color: AppColors.gray900),
            ),
            SizedBox(height: AppDimens.h16),
            MealTimeWidget(
              selectedMealLabel: mealLabel,
              callback: (mealLabel) => _onMealTimeChanged(context: context, mealLabel: mealLabel),
            ),
          ],
        ),
      ),
    );
  }

  void _onMealTimeChanged({required BuildContext context, required MealLabel mealLabel}) {
    context.read<EditFoodBloc>().add(DoUpdateMealLabelEvent(mealLabel: mealLabel));
  }
}
