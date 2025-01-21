import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/util/double_extensions.dart';
import '../bloc/edit_nutrition_facts_bloc.dart';
import '../widgets/portion_widget.dart';

class PortionSection extends StatefulWidget {
  const PortionSection({super.key});

  @override
  State<PortionSection> createState() => _PortionSectionState();
}

class _PortionSectionState extends State<PortionSection> {
  // late TextEditingController _servingController;
  // late TextEditingController _weightController;
  List<String> _units = [];
  String _selectedUnit = '';

  @override
  Widget build(BuildContext context) {
    return BlocListener<EditNutritionFactsBloc, EditNutritionFactsState>(
      listener: (context, state) {
        if (state is UpdatePortionsState) {
          // _servingController.text = state.selectedQuantity.format();
          // _weightController.text = state.weight?.value.format() ?? '';
          _selectedUnit = state.selectedUnit ?? '';
          _units = state.units ?? [];
        }
      },
      child: BlocBuilder<EditNutritionFactsBloc, EditNutritionFactsState>(
        buildWhen: (_, state) {
          return state is UpdatePortionsState;
        },
        builder: (context, state) {
          String? selectedQuantity;
          String? selectedUnit;
          String? weight;
          if (state is UpdatePortionsState) {
            selectedQuantity = state.selectedQuantity;
            selectedUnit = state.selectedUnit;
            weight = state.weight;
            // _servingController.text = state.selectedQuantity.format();
            // _weightController.text = state.weight?.value.format() ?? '';
            _selectedUnit = state.selectedUnit ?? '';
            _units = state.units ?? [];
          }
          return PortionWidget(
            initialSelectedQuantity: selectedQuantity,
            initialSelectedUnit: selectedUnit,
            initialWeight: weight,
            // servingController: _servingController,
            // weightController: _weightController,
            // units: _units,
            // selectedUnit: _selectedUnit,
          );
        },
      ),
    );
  }
}
