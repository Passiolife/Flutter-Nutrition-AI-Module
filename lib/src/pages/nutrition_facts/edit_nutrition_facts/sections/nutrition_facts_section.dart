import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/extension/null_safety_extension.dart';
import '../../../../common/util/double_extensions.dart';
import '../bloc/edit_nutrition_facts_bloc.dart';
import '../widgets/nutrition_facts_widget.dart';

class NutritionFactsSection extends StatefulWidget {
  const NutritionFactsSection({super.key});

  @override
  State<NutritionFactsSection> createState() => _NutritionFactsSectionState();
}

class _NutritionFactsSectionState extends State<NutritionFactsSection> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditNutritionFactsBloc, EditNutritionFactsState>(
      buildWhen: (_, state) {
        return state is UpdateNutritionFactsState;
      },
      builder: (context, state) {
        String? calories;
        String? carbs;
        String? protein;
        String? fat;
        if (state is UpdateNutritionFactsState) {
          calories = state.calories;
          carbs = state.carbs;
          protein = state.protein;
          fat = state.fat;
        }
        return NutritionFactsWidget(
          initialCalories: calories,
          initialCarbs: carbs,
          initialProtein: protein,
          initialFat: fat,
        );
      },
    );
  }
}
