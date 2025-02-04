import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/constant/app_colors.dart';
import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/extension/number_extension.dart';
import '../../../../../common/models/daily_nutrition_model.dart';
import '../../../../../common/util/double_extensions.dart';
import '../bloc/take_photo_result_bloc.dart';
import '../../../../../common/widgets/passio/macros_graph_widget.dart';

class MacrosGraphSection extends StatelessWidget {
  const MacrosGraphSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TakePhotoResultBloc, TakePhotoResultState>(
      buildWhen: (_, state) {
        return state is TakePhotoResultInitial || state is UpdateMacroNutrientState;
      },
      builder: (context, state) {
        if (state is! UpdateMacroNutrientState) return const SizedBox.shrink();

        final listNutrition = state.listMacros;
        /*int calories = state.viewModel.calories.toInt();
        int caloriesTarget = state.viewModel.caloriesTarget.toInt();
        double carbs = state.viewModel.carbs;
        double carbsTarget = state.viewModel.carbsTarget;
        double protein = state.viewModel.protein;
        double proteinTarget = state.viewModel.proteinTarget;
        double fat = state.viewModel.fat;
        double fatTarget = state.viewModel.fatTarget;
        List<DailyNutritionModel> listNutrition = [
          DailyNutritionModel(
            title: '$calories',
            subtitle: caloriesTarget.format(),
            footer: context.localization.calories!,
            value: calories > 0 ? 1 : 0,
            progressColor: AppColors.yellow500,
            backgroundColor: AppColors.brandPrimaryLight,
          ),
          DailyNutritionModel(
            title: '${carbs.format(places: 1)} g',
            subtitle: '${carbsTarget.format()} g',
            footer: context.localization.carbs!,
            value: carbs > 0 ? 1 : 0,
            progressColor: AppColors.lBlue500Normal,
            backgroundColor: AppColors.brandPrimaryLight,
          ),
          DailyNutritionModel(
            title: '${protein.format(places: 1)} g',
            subtitle: '${proteinTarget.format()} g',
            footer: context.localization.protein!,
            value: protein > 0 ? 1 : 0,
            progressColor: AppColors.green500Success,
            backgroundColor: AppColors.brandPrimaryLight,
          ),
          DailyNutritionModel(
            title: '${fat.format(places: 1)} g',
            subtitle: '${fatTarget.format()} g',
            footer: context.localization.fat!,
            value: fat > 0 ? 1 : 0,
            progressColor: AppColors.purple500,
            backgroundColor: AppColors.brandPrimaryLight,
          ),
        ]*/;
        return MacrosGraphWidget(listNutrition: listNutrition);
      },
    );
  }
}
