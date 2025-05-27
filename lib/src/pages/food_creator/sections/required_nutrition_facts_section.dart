import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/models/key_value_model.dart';
import '../../../common/util/double_extensions.dart';
import '../bloc/food_creator_bloc.dart';
import '../widgets/required_nutrition_facts_widget.dart';

class RequiredNutritionFactsSection extends StatelessWidget {
  const RequiredNutritionFactsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<KeyValueModel<String>> units =
        context.read<FoodCreatorBloc>().creatorModel.units;

    return BlocBuilder<FoodCreatorBloc, FoodCreatorState>(
      buildWhen: (_, state) {
        return state is InitialState || state is UnitChangedState || state is WeightSymbolChangedState;
      },
      builder: (context, state) {
        final KeyValueModel<String>? selectedUnit =
            context.read<FoodCreatorBloc>().creatorModel.unit;
        final bool weightVisible =
            context.read<FoodCreatorBloc>().visibleWeight;

        final String initialServingSize = context
                .read<FoodCreatorBloc>()
                .creatorModel
                .getServingSize()
                ?.toString() ??
            '';

        final String initialWeight = context
                .read<FoodCreatorBloc>()
                .creatorModel
                .getWeight()
                ?.toString() ??
            '';

        final String initialCalories = context
            .read<FoodCreatorBloc>()
            .creatorModel
            .getCalories()?.format() ?? '';
        final String initialFat =
            context.read<FoodCreatorBloc>().creatorModel.getFat()?.toString() ?? '';
        final String initialCarbs =
            context.read<FoodCreatorBloc>().creatorModel.getCarbs()?.format() ?? '';
        final String initialProtein = context
            .read<FoodCreatorBloc>()
            .creatorModel
            .getProtein()
            ?.format() ?? '';

        final List<KeyValueModel<String>> weightSymbols =
            context.read<FoodCreatorBloc>().creatorModel.weightSymbols;

        final KeyValueModel<String> initialWeightSymbol = context
            .read<FoodCreatorBloc>()
            .creatorModel.getSelectedWeightSymbol();

        return RequiredNutritionFactsWidget(
          initialWeightSymbol: initialWeightSymbol,
          initialServingSize: initialServingSize,
          onChangedServingSize: (value) =>
              _onServingSizeChanged(context: context, value: value),
          units: units,
          initialUnit: selectedUnit,
          weightVisible: weightVisible,
          onChangedUnit: (value) => _onUnitChanged(
            context: context,
            value: value,
          ),
          initialWeight: initialWeight,
          onChangedWeight: (value) =>
              _onWeightChanged(context: context, value: value),
          weightSymbols: weightSymbols,
          onChangedWeightSymbol: (value) => _onWeightSymbolChanged(
            context: context,
            value: value,
          ),
          initialCalories: initialCalories,
          onChangedCalories: (value) => _onCaloriesChanged(
            context: context,
            value: value,
          ),
          initialFat: initialFat,
          onChangedFat: (value) =>
              _onFatChanged(context: context, value: value),
          initialCarbs: initialCarbs,
          onChangedCarbs: (value) => _onCarbsChanged(
            context: context,
            value: value,
          ),
          initialProtein: initialProtein,
          onChangedProtein: (value) => _onProteinChanged(
            context: context,
            value: value,
          ),
        );
      },
    );
  }

  void _onServingSizeChanged({
    required BuildContext context,
    required String value,
  }) {
    context
        .read<FoodCreatorBloc>()
        .add(UpdateServingSizeEvent(servingSize: value));
  }

  void _onUnitChanged({
    required BuildContext context,
    KeyValueModel<String>? value,
  }) {
    context.read<FoodCreatorBloc>().add(UpdateUnitEvent(unit: value));
  }

  void _onWeightChanged({
    required BuildContext context,
    required String value,
  }) {
    context.read<FoodCreatorBloc>().add(UpdateWeightEvent(weight: value));
  }

  void _onCaloriesChanged({
    required BuildContext context,
    required String value,
  }) {
    context.read<FoodCreatorBloc>().add(UpdateCaloriesEvent(calories: value));
  }

  void _onFatChanged({
    required BuildContext context,
    required String value,
  }) {
    context.read<FoodCreatorBloc>().add(UpdateFatEvent(fat: value));
  }

  void _onCarbsChanged({
    required BuildContext context,
    required String value,
  }) {
    context.read<FoodCreatorBloc>().add(UpdateCarbsEvent(carbs: value));
  }

  void _onProteinChanged({
    required BuildContext context,
    required String value,
  }) {
    context.read<FoodCreatorBloc>().add(UpdateProteinEvent(protein: value));
  }

  void _onWeightSymbolChanged(
      {required BuildContext context, KeyValueModel<String>? value}) {
    context
        .read<FoodCreatorBloc>()
        .add(UpdateWeightSymbolEvent(weightSymbol: value));
  }
}
