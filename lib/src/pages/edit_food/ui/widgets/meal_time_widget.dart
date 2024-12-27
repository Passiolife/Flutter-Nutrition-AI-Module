import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/models/food_record/meal_label.dart';
import '../../../../common/extension/string_extensions.dart';

typedef MealLabelCallback = void Function(MealLabel mealLabel);

class MealTimeWidget extends StatefulWidget {
  const MealTimeWidget({
    super.key,
    this.selectedMealLabel,
    this.callback,
  });

  final MealLabel? selectedMealLabel;
  final MealLabelCallback? callback;

  @override
  State<MealTimeWidget> createState() => _MealTimeWidgetState();
}

class _MealTimeWidgetState extends State<MealTimeWidget> {
  final ValueNotifier<MealLabel?> _selectedMealLabel = ValueNotifier(null);

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _selectedMealLabel.value = widget.selectedMealLabel;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: _SegmentedButtonThemeDataWidget(
        child: ValueListenableBuilder(
          valueListenable: _selectedMealLabel,
          builder: (context, value, child) {
            return SegmentedButton<MealLabel?>(
              showSelectedIcon: false,
              selected: <MealLabel?>{value},
              onSelectionChanged: (value) {
                _selectedMealLabel.value = value.first;
                if (_selectedMealLabel.value != null) {
                  widget.callback?.call(_selectedMealLabel.value!);
                }
              },
              segments: MealLabel.values
                  .map(
                    (e) => ButtonSegment<MealLabel>(
                      value: e,
                      label: Text(e.name.toUpperCaseWord),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}

class _SegmentedButtonThemeDataWidget extends StatelessWidget {
  final Widget child;

  const _SegmentedButtonThemeDataWidget({required this.child});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: ButtonStyle(
            visualDensity: VisualDensity.standard,
            padding: WidgetStateProperty.all(EdgeInsets.zero),
            side: WidgetStateProperty.all(
              const BorderSide(color: AppColors.gray200),
            ),
            shape: WidgetStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.indigo600Main;
              } else {
                return AppColors.white;
              }
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.white;
              } else {
                return AppColors.gray500;
              }
            }),
          ),
        ),
      ),
      child: child,
    );
  }
}
