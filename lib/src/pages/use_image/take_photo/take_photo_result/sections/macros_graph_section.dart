import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/constant/app_colors.dart';
import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/models/daily_nutrition_model.dart';
import '../../../../../common/util/double_extensions.dart';
import '../bloc/take_photo_result_bloc.dart';
import '../widgets/macros_graph_widget.dart';

class MacrosGraphSection extends StatelessWidget {
  const MacrosGraphSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TakePhotoResultBloc, TakePhotoResultState>(
      buildWhen: (_, state) {
        return state is TakePhotoResultInitial || state is ResultsSuccessState;
      },
      builder: (context, state) {
        if (state is! ResultsSuccessState) return const SizedBox.shrink();

        final foodItems = state.foodItems;
        double calories = foodItems.fold(0.0, (previousValue, element) => previousValue + element.calories);
        double carbs = foodItems.fold(0.0, (previousValue, element) => previousValue + element.carbs);
        double protein = foodItems.fold(0.0, (previousValue, element) => previousValue + element.protein);
        double fat = foodItems.fold(0.0, (previousValue, element) => previousValue + element.fat);
        List<DailyNutritionModel> listNutrition = [
          DailyNutritionModel(
            title: '${calories.toInt()}',
            subtitle: '1,512',
            footer: context.localization.calories!,
            value: 0.5,
            progressColor: AppColors.yellow500,
            backgroundColor: AppColors.brandPrimaryLight,
          ),
          DailyNutritionModel(
            title: '${carbs.format(places: 1)} g',
            subtitle: '170 g',
            footer: context.localization.carbs!,
            value: 0.5,
            progressColor: AppColors.lBlue500Normal,
            backgroundColor: AppColors.brandPrimaryLight,
          ),
          DailyNutritionModel(
            title: '${protein.format(places: 1)} g',
            subtitle: '113 g',
            footer: context.localization.protein!,
            value: 0.5,
            progressColor: AppColors.green500Success,
            backgroundColor: AppColors.brandPrimaryLight,
          ),
          DailyNutritionModel(
            title: '${fat.format(places: 1)} g',
            subtitle: '42 g',
            footer: context.localization.fat!,
            value: 0.5,
            progressColor: AppColors.purple500,
            backgroundColor: AppColors.brandPrimaryLight,
          ),
        ];
        return MacrosGraphWidget(listNutrition: listNutrition);
      },
    );
  }
}
