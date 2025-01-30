import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/edit_nutrition_facts_bloc.dart';
import '../../../../common/widgets/edit_nutrition_facts/portion_widget.dart';

class PortionSection extends StatelessWidget {
  const PortionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditNutritionFactsBloc, EditNutritionFactsState>(
      buildWhen: (_, state) {
        return state is RefreshPortionsState;
      },
      builder: (context, state) {
        String? selectedQuantity;
        String? selectedUnit;
        String? weight;
        List<String> units = [];

        if (state is RefreshPortionsState) {
          selectedQuantity = state.selectedQuantity;
          selectedUnit = state.selectedUnit;
          weight = state.weight;
          selectedUnit = state.selectedUnit ?? '';
          units = state.units ?? [];
        }
        return PortionWidget(
          initialSelectedQuantity: selectedQuantity,
          initialSelectedUnit: selectedUnit,
          initialWeight: weight,
          units: units,
          onChange: (quantity, unit, weight) => _onChange(
            context: context,
            quantity: quantity,
            unit: unit,
            weight: weight,
          ),
        );
      },
    );
  }

  void _onChange({
    required BuildContext context,
    required double? quantity,
    required String? unit,
    required double? weight,
  }) {
    context.read<EditNutritionFactsBloc>().add(
          UpdatePortionsEvent(
            quantity: quantity,
            weight: weight,
            unit: unit,
          ),
        );
  }
}
