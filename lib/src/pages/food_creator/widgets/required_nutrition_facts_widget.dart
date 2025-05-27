import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/extension/core_extension.dart';
import '../../../common/models/key_value_model.dart';
import '../../../common/widgets/drop_down/secondary_dropdown.dart';
import '../../../common/widgets/drop_down_button/primary_drop_down_button.dart';
import '../../../common/widgets/text_input/number_text_input.dart';

class RequiredNutritionFactsWidget extends StatelessWidget {
  const RequiredNutritionFactsWidget({
    required this.units,
    required this.weightSymbols,
    this.initialServingSize,
    this.onChangedServingSize,
    this.initialUnit,
    this.onChangedUnit,
    this.weightVisible = true,
    this.initialWeight,
    this.onChangedWeight,
    this.initialWeightSymbol,
    this.onChangedWeightSymbol,
    this.initialCalories,
    this.onChangedCalories,
    this.initialFat,
    this.onChangedFat,
    this.initialCarbs,
    this.onChangedCarbs,
    this.initialProtein,
    this.onChangedProtein,
    super.key,
  });

  // Serving Size
  final String? initialServingSize;
  final ValueChanged<String>? onChangedServingSize;

  // Units
  final KeyValueModel<String>? initialUnit;
  final List<KeyValueModel<String>> units;
  final ValueChanged<KeyValueModel<String>?>? onChangedUnit;

  // Weight
  final bool weightVisible;
  final String? initialWeight;
  final ValueChanged<String>? onChangedWeight;
  // Symbols
  final KeyValueModel<String>? initialWeightSymbol;
  final List<KeyValueModel<String>> weightSymbols;
  final ValueChanged<KeyValueModel<String>?>? onChangedWeightSymbol;

  // Calories
  final String? initialCalories;
  final ValueChanged<String>? onChangedCalories;

  // Fat
  final String? initialFat;
  final ValueChanged<String>? onChangedFat;

  // Carbs
  final String? initialCarbs;
  final ValueChanged<String>? onChangedCarbs;

  // Protein
  final String? initialProtein;
  final ValueChanged<String>? onChangedProtein;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      padding: AppPadding.pa16,
      margin: AppPadding.pt16 + AppPadding.ph16 + AppPadding.pb8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            context.localization.requiredNutritionFacts,
            style: AppTextStyle.textBase.addAll([
              AppTextStyle.textBase.leading6,
              AppTextStyle.semiBold,
            ]).copyWith(color: AppColors.black),
          ),
          16.verticalSpace,
          _NutritionInputRow(
            label: context.localization.servingSize,
            hintText: context.localization.value.toUpperCaseWord,
            initialValue: initialServingSize,
            onFieldSubmitted: onChangedServingSize,
          ),
          16.verticalSpace,
          _NutritionSelectionRow(
            label: context.localization.units.toUpperCaseWord,
            hintText: context.localization.value.toUpperCaseWord,
            options: units,
            selected: initialUnit,
            onSelected: onChangedUnit,
          ),
          if (weightVisible)
            Padding(
              padding: AppPadding.pt16,
              child: _NutritionInputRow(
                label: context.localization.weight,
                hintText: context.localization.value.toUpperCaseWord,
                suffix: UnconstrainedBox(
                  child: PrimaryDropDownButton<String>(
                    options: weightSymbols,
                    selected: initialWeightSymbol,
                    onChanged: onChangedWeightSymbol,
                  ),
                ),
                initialValue: initialWeight,
                onFieldSubmitted: onChangedWeight,
              ),
            ),
          16.verticalSpace,
          _NutritionInputRow(
            label: context.localization.calories,
            hintText: context.localization.value.toUpperCaseWord,
            initialValue: initialCalories,
            onFieldSubmitted: onChangedCalories,
          ),
          16.verticalSpace,
          _NutritionInputRow(
            label: context.localization.fat,
            hintText: context.localization.value.toUpperCaseWord,
            initialValue: initialFat,
            onFieldSubmitted: onChangedFat,
          ),
          16.verticalSpace,
          _NutritionInputRow(
            label: context.localization.carbs,
            hintText: context.localization.value.toUpperCaseWord,
            initialValue: initialCarbs,
            onFieldSubmitted: onChangedCarbs,
          ),
          16.verticalSpace,
          _NutritionInputRow(
            label: context.localization.protein,
            hintText: context.localization.value.toUpperCaseWord,
            initialValue: initialProtein,
            onFieldSubmitted: onChangedProtein,
          ),
        ],
      ),
    );
  }
}

class _NutritionSelectionRow extends StatelessWidget {
  const _NutritionSelectionRow({
    required this.label,
    required this.hintText,
    required this.options,
    this.selected,
    this.onSelected,
  });

  final String label;
  final String hintText;
  final KeyValueModel<String>? selected;
  final List<KeyValueModel<String>> options;
  final ValueChanged<KeyValueModel<String>?>? onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyle.textSm.addAll([
              AppTextStyle.textSm.leading5,
              AppTextStyle.medium
            ]).copyWith(color: context.textThemeColors.brandTextLight),
          ),
        ),
        Expanded(
          flex: 2,
          child: SecondaryDropdown(
            hint: hintText,
            value: selected,
            options: options,
            onSelected: onSelected,
            validator: (value) {
              if (value == null) {
                return '';
              }
              return null;
            }

          ),
        ),
      ],
    );
  }
}

class _NutritionInputRow extends StatefulWidget {
  const _NutritionInputRow({
    required this.label,
    required this.hintText,
    this.initialValue,
    this.suffix,
    this.onFieldSubmitted,
  });

  final String label;
  final String hintText;
  final String? initialValue;
  final ValueChanged<String>? onFieldSubmitted;
  final Widget? suffix;

  @override
  State<_NutritionInputRow> createState() => _NutritionInputRowState();
}

class _NutritionInputRowState extends State<_NutritionInputRow> {

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void didUpdateWidget(covariant _NutritionInputRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (oldWidget.initialValue != widget.initialValue) {
        _controller.text = widget.initialValue ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.label,
            style: AppTextStyle.textSm.addAll([
              AppTextStyle.textSm.leading5,
              AppTextStyle.medium
            ]).copyWith(color: context.textThemeColors.brandTextLight),
          ),
        ),
        Expanded(
          flex: 2,
          child: NumberTextInput(
            hintText: widget.hintText,
            controller: _controller,
            onFieldSubmitted: widget.onFieldSubmitted,
            suffix: widget.suffix,
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return '';
              }
              return null;
            },
            autoValidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
      ],
    );
  }
}
