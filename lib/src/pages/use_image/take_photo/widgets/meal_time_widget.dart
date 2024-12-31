import 'package:flutter/material.dart';

import '../../../../common/extension/context_extension.dart';
import '../../../../common/models/food_record/meal_label.dart';
import '../../../../common/models/key_value_model.dart';
import '../../../../common/widgets/drop_down/primary_dropdown.dart';

class MealTime extends StatefulWidget {
  const MealTime({super.key, this.initialMealTime, this.onSelected});

  final MealLabel? initialMealTime;
  final ValueChanged<KeyValueModel<MealLabel>?>? onSelected;

  @override
  State<MealTime> createState() => _MealTimeState();
}

class _MealTimeState extends State<MealTime> {
  KeyValueModel<MealLabel>? _selectedMealLabel;
  final List<KeyValueModel<MealLabel>> _mealTimes = MealLabel.values
      .map((e) => KeyValueModel(text: e.value, value: e))
      .toList();

  @override
  void initState() {
    if (widget.initialMealTime != null) {
      _selectedMealLabel = KeyValueModel(
          text: widget.initialMealTime!.value, value: widget.initialMealTime!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryDropdown<MealLabel>(
      label: context.localization?.mealTime ?? '',
      value: _selectedMealLabel,
      options: _mealTimes,
      onSelected: (value) {
        if (value == null) return;
        widget.onSelected?.call(value);
        setState(() {
          _selectedMealLabel = value;
        });
      },
    );
  }
}
