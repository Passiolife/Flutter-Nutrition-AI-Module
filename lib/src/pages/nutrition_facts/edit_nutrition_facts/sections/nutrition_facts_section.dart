import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/edit_nutrition_facts_bloc.dart';
import '../../../../common/widgets/edit_nutrition_facts/nutrition_facts_widget.dart';

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
        return state is RefreshNutritionFactsState;
      },
      builder: (context, state) {
        String? calories;
        String? carbs;
        String? protein;
        String? fat;
        if (state is RefreshNutritionFactsState) {
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
          onChange: (calories, carbs, protein, fat) {
            _onChange(
              context: context,
              calories: calories,
              carbs: carbs,
              protein: protein,
              fat: fat,
            );
          },
        );
      },
    );
  }

  void _onChange({
    required BuildContext context,
    required double? calories,
    required double? carbs,
    required double? protein,
    required double? fat,
  }) {
    context.read<EditNutritionFactsBloc>().add(
          UpdateNutritionFactsEvent(
            calories: calories,
            carbs: carbs,
            protein: protein,
            fat: fat,
          ),
        );
  }
}
