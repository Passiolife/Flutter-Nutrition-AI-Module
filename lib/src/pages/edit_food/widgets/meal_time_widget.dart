import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/models/food_record/meal_label.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/string_extensions.dart';
import 'interfaces.dart';

class MealTimeWidget extends StatefulWidget {
  MealTimeWidget({this.selectedMealLabel, this.listener})
      : super(key: ObjectKey(selectedMealLabel));

  final MealLabel? selectedMealLabel;
  final EditFoodListener? listener;

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
    return Container(
      decoration: AppShadows.base,
      padding: EdgeInsets.all(AppDimens.r16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.localization?.mealTime ?? '',
            style: AppTextStyle.textBase.addAll([
              AppTextStyle.textBase.leading6,
              AppTextStyle.semiBold
            ]).copyWith(color: AppColors.gray900),
          ),
          SizedBox(height: AppDimens.h16),
          SizedBox(
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
                        widget.listener
                            ?.onChangeMealTime(_selectedMealLabel.value!);
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
          ),
        ],
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
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            side: MaterialStateProperty.all(
              const BorderSide(color: AppColors.gray200),
            ),
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            backgroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return AppColors.indigo600Main;
              } else {
                return AppColors.white;
              }
            }),
            foregroundColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
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
