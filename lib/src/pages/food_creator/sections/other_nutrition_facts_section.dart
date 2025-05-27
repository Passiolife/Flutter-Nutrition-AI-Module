import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/extension/context_extension.dart';
import '../../../common/models/key_value_model.dart';
import '../bloc/food_creator_bloc.dart';
import '../widgets/other_nutrition_facts_widget.dart';

class OtherNutritionFactsSection extends StatelessWidget {
  const OtherNutritionFactsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodCreatorBloc, FoodCreatorState>(
      buildWhen: (_, state) => state is InitialState || state is OtherNutritionFactsSelectedState || state is OtherNutritionFactsRemovedState,
      builder: (context, state) {
        final List<KeyValueModel<UnitMass>> selectedOptions = context.read<FoodCreatorBloc>().creatorModel.selectedOtherNutritionFacts;

        final List<KeyValueModel<UnitMass>> remainingOtherNutritionFacts =
            context
                .read<FoodCreatorBloc>()
                .creatorModel
                .remainingOtherNutritionFacts;
        return OtherNutritionFactsWidget(
          hintText: context.localization.selectNutrient,
          options: remainingOtherNutritionFacts,
          selectedOptions: selectedOptions,
          onSelected: (value) => _onSelected(context: context, value: value),
          onChangedOption: (value) => _onChangedOption(context: context, value: value),
          onDelete: (value) => _onDelete(context: context, value: value),
        );
      },
    );
  }

  void _onSelected({
    required BuildContext context,
    required KeyValueModel<UnitMass>? value,
  }) {
    if (value == null) return;
    context.read<FoodCreatorBloc>().add(
      SelectOtherNutritionFactsEvent(selectedNutrient: value),
        );
  }

  void _onDelete({
    required BuildContext context,
    required KeyValueModel<UnitMass>? value,
  }) {
    if (value == null) return;
    context.read<FoodCreatorBloc>().add(
          RemoveOtherNutritionFactsEvent(selectedNutrient: value),
        );
  }

  void _onChangedOption({
    required BuildContext context,
    required KeyValueModel<UnitMass>? value,
  }) {
    if (value == null) return;
    context.read<FoodCreatorBloc>().add(
          UpdateOtherNutritionFactsEvent(selectedNutrient: value),
        );
  }
}
