import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/dialogs/ok_button_with_keyboard.dart';
import '../../../common/models/user_profile/user_profile_model.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/double_extensions.dart';
import '../../../common/widgets/app_drop_down_menu.dart';
import '../../../common/widgets/app_text_field.dart';
import 'labeled_widget_row.dart';

abstract class NutritionGoalsListener {
  void onTargetWeightChanged(double? targetWeight);

  void onActivityLevelChanged(ActivityLevel activityLevel);

  void onCalorieDeficitChanged(CalorieDeficit calorieDeficit);

  void onDietChanged(PassioMealPlan mealPlan);

  void onTargetWaterChanged(double? targetWater);
}

class NutritionGoalsWidget extends StatefulWidget {
  const NutritionGoalsWidget({
    this.targetWeight,
    this.weightUnit = MeasurementSystem.imperial,
    this.targetWater,
    this.activityLevel,
    this.calorieDeficit,
    this.mealPlans,
    this.selectedMealPlan,
    this.listener,
    super.key,
  });

  final double? targetWeight;
  final double? targetWater;
  final MeasurementSystem weightUnit;

  final ActivityLevel? activityLevel;
  final CalorieDeficit? calorieDeficit;

  final List<PassioMealPlan>? mealPlans;
  final PassioMealPlan? selectedMealPlan;

  final NutritionGoalsListener? listener;

  @override
  State<NutritionGoalsWidget> createState() => _NutritionGoalsWidgetState();
}

class _NutritionGoalsWidgetState extends State<NutritionGoalsWidget> {
  final TextEditingController _targetWeightController = TextEditingController();
  final TextEditingController _targetWaterController = TextEditingController();

  final FocusNode _targetWeightFocusNode = FocusNode();
  final FocusNode _targetWaterFocusNode = FocusNode();

  List<DropdownMenuEntry<ActivityLevel>> get _activityLevelEntries => [
        DropdownMenuEntry(
          value: ActivityLevel.notActive,
          label: context.localization?.notActive ?? '',
        ),
        DropdownMenuEntry(
          value: ActivityLevel.moderatelyActive,
          label: context.localization?.moderatelyActive ?? '',
        ),
        DropdownMenuEntry(
          value: ActivityLevel.lightlyActive,
          label: context.localization?.lightlyActive ?? '',
        ),
        DropdownMenuEntry(
          value: ActivityLevel.active,
          label: context.localization?.active ?? '',
        ),
      ];

  // Calorie Deficit DropDown Data
  String get loseString => context.localization?.lose ?? '';

  String get gainString => context.localization?.gain ?? '';

  String get weekString => context.localization?.week ?? '';

  String get lengthUnitSymbol => widget.weightUnit == MeasurementSystem.imperial
      ? context.localization?.lbs ?? ''
      : context.localization?.kg ?? '';

  List<DropdownMenuEntry<CalorieDeficit>> get _calorieDeficitEntries => [
        DropdownMenuEntry(
          value: CalorieDeficit.lose0_5,
          label:
              '$loseString ${CalorieDeficit.lose0_5.getValue(widget.weightUnit).format()} $lengthUnitSymbol / $weekString',
        ),
        DropdownMenuEntry(
          value: CalorieDeficit.lose1_0,
          label:
              '$loseString ${CalorieDeficit.lose1_0.getValue(widget.weightUnit).format()} $lengthUnitSymbol / $weekString',
        ),
        DropdownMenuEntry(
          value: CalorieDeficit.lose1_5,
          label:
              '$loseString ${CalorieDeficit.lose1_5.getValue(widget.weightUnit).format()} $lengthUnitSymbol / $weekString',
        ),
        DropdownMenuEntry(
          value: CalorieDeficit.lose2_0,
          label:
              '$loseString ${CalorieDeficit.lose2_0.getValue(widget.weightUnit).format()} $lengthUnitSymbol / $weekString',
        ),
        DropdownMenuEntry(
          value: CalorieDeficit.gain0_5,
          label:
              '$gainString ${CalorieDeficit.gain0_5.getValue(widget.weightUnit).format()} $lengthUnitSymbol / $weekString',
        ),
        DropdownMenuEntry(
          value: CalorieDeficit.gain1_0,
          label:
              '$gainString ${CalorieDeficit.gain1_0.getValue(widget.weightUnit).format()} $lengthUnitSymbol / $weekString',
        ),
        DropdownMenuEntry(
          value: CalorieDeficit.gain1_5,
          label:
              '$gainString ${CalorieDeficit.gain1_5.getValue(widget.weightUnit).format()} $lengthUnitSymbol / $weekString',
        ),
        DropdownMenuEntry(
          value: CalorieDeficit.gain2_0,
          label:
              '$gainString ${CalorieDeficit.gain2_0.getValue(widget.weightUnit).format()} $lengthUnitSymbol / $weekString',
        ),
        DropdownMenuEntry(
          value: CalorieDeficit.maintainWeight,
          label: context.localization?.maintainWeight ?? '',
        ),
      ];

  List<DropdownMenuEntry<PassioMealPlan>> get _mealPlansEntries =>
      widget.mealPlans
          ?.map(
            (e) => DropdownMenuEntry(
              value: e,
              label: e.mealPlanTitle,
            ),
          )
          .toList() ?? [];

  // END

  @override
  void initState() {
    _targetWeightController.text = widget.targetWeight?.format() ?? '';
    _targetWaterController.text = widget.targetWater?.format() ?? '';

    // Focus Node
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      // Focus Node
      OkButtonWithKeyboard.setup(
        context: context,
        focusNode: _targetWeightFocusNode,
        onTap: () {
          _targetWeightController.text =
              double.tryParse(_targetWeightController.text.trim())
                  .format();
        },
      );
      OkButtonWithKeyboard.setup(
        context: context,
        focusNode: _targetWaterFocusNode,
        onTap: () {
          _targetWaterController.text =
              double.tryParse(_targetWaterController.text.trim())
                  .format();
        },
      );
    });

    // Listener
    _targetWeightController.addListener(() {
      widget.listener?.onTargetWeightChanged(
          double.tryParse(_targetWeightController.text.trim()));
    });

    _targetWaterController.addListener(() {
      widget.listener?.onTargetWaterChanged(
          double.tryParse(_targetWaterController.text.trim()));
    });
    super.initState();
  }

  @override
  void dispose() {
    _targetWeightFocusNode.dispose();
    _targetWaterFocusNode.dispose();
    _targetWeightController.dispose();
    _targetWaterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.localization?.nutritionGoals ?? '',
            style: AppTextStyle.textBase.addAll(
                [AppTextStyle.textBase.leading6, AppTextStyle.semiBold]),
          ),
          16.verticalSpace,
          LabeledWidgetRow(
            title: context.localization?.targetWeight,
            child: AppTextField(
              controller: _targetWeightController,
              focusNode: _targetWeightFocusNode,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
              ],
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: AppDimens.w8),
                child: Text(
                  widget.weightUnit == MeasurementSystem.imperial
                      ? WeightUnits.lbs.name
                      : WeightUnits.kg.name,
                  // widget.unit ?? '',
                  style: AppTextStyle.textBase
                      .addAll([AppTextStyle.textBase.leading6]).copyWith(
                          color: AppColors.gray900),
                ),
              ),
              suffixIconConstraints: BoxConstraints(
                  minHeight: AppTextStyle.textBase.fontSize ?? 14),
              style: AppTextStyle.textBase
                  .addAll([AppTextStyle.textBase.leading6]),
            ),
          ),
          16.verticalSpace,
          LabeledWidgetRow(
            title: context.localization?.activityLevel,
            child: AppDropDownMenu<ActivityLevel>(
              initialSelection: widget.activityLevel,
              dropdownMenuEntries: _activityLevelEntries,
              onSelected: (value) {
                if (value != null) {
                  widget.listener?.onActivityLevelChanged(value);
                }
              },
            ),
          ),
          16.verticalSpace,
          LabeledWidgetRow(
            title: context.localization?.calorieDeficit,
            child: AppDropDownMenu<CalorieDeficit>(
              initialSelection: widget.calorieDeficit,
              dropdownMenuEntries: _calorieDeficitEntries,
              onSelected: (value) {
                if (value != null) {
                  widget.listener?.onCalorieDeficitChanged(value);
                }
              },
            ),
          ),
          16.verticalSpace,
          LabeledWidgetRow(
            title: context.localization?.diet,
            child: AppDropDownMenu<PassioMealPlan>(
              initialSelection: widget.selectedMealPlan,
              dropdownMenuEntries: _mealPlansEntries,
              onSelected: (value) {
                if (value != null) {
                  widget.listener?.onDietChanged(value);
                }
              },
            ),
          ),
          16.verticalSpace,
          LabeledWidgetRow(
            title: context.localization?.waterTarget,
            child: AppTextField(
              controller: _targetWaterController,
              focusNode: _targetWaterFocusNode,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*')),
              ],
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              suffixIcon: Padding(
                padding: EdgeInsets.only(right: AppDimens.w8),
                child: Text(
                  widget.weightUnit == MeasurementSystem.imperial
                      ? WaterUnits.oz.name
                      : WaterUnits.ml.name,
                  // widget.unit ?? '',
                  style: AppTextStyle.textBase
                      .addAll([AppTextStyle.textBase.leading6]).copyWith(
                          color: AppColors.gray900),
                ),
              ),
              suffixIconConstraints: BoxConstraints(
                  minHeight: AppTextStyle.textBase.fontSize ?? 14),
              style: AppTextStyle.textBase
                  .addAll([AppTextStyle.textBase.leading6]),
            ),
          ),
        ],
      ),
    );
  }
}
