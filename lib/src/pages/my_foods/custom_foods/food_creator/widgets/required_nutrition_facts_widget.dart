import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../../../common/constant/app_constants.dart';
import '../../../../../common/dialogs/ok_button_with_keyboard.dart';
import '../../../../../common/util/context_extension.dart';
import '../../../../../common/util/double_extensions.dart';
import '../../../../../common/util/string_extensions.dart';
import '../../../../../common/util/text_input_formatter_util.dart';
import '../../../../../common/widgets/app_drop_down_menu.dart';
import '../../../../../common/widgets/app_text_field.dart';

typedef OnChangeRequiredNutritionFacts = Function(
  double? servingQuantity,
  String? unit,
  double? weightValue,
  String? weightSymbol,
  Unit? calories,
  Unit? fat,
  Unit? carbs,
  Unit? protein,
);

class RequiredNutritionFactsWidget extends StatefulWidget {
  const RequiredNutritionFactsWidget({
    this.initialServingSize,
    this.initialUnit,
    this.initialWeightValue,
    this.initialWeightSymbol,
    this.initialCalories,
    this.initialFat,
    this.initialCarbs,
    this.initialProtein,
    this.onChange,
    super.key,
  });

  final double? initialServingSize;
  final String? initialUnit;
  final double? initialWeightValue;
  final String? initialWeightSymbol;
  final Unit? initialCalories;
  final Unit? initialFat;
  final Unit? initialCarbs;
  final Unit? initialProtein;
  final OnChangeRequiredNutritionFacts? onChange;

  @override
  State<RequiredNutritionFactsWidget> createState() =>
      _RequiredNutritionFactsWidgetState();
}

class _RequiredNutritionFactsWidgetState
    extends State<RequiredNutritionFactsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.localization?.requiredNutritionFacts ?? '',
            style: AppTextStyle.textBase.addAll([
              AppTextStyle.textBase.leading6,
              AppTextStyle.semiBold,
            ]),
          ),
          8.verticalSpace,
          _FormWidget(
            initialServingQuantity: widget.initialServingSize,
            initialUnit: widget.initialUnit,
            initialWeightValue: widget.initialWeightValue,
            initialWeightSymbol: widget.initialWeightSymbol,
            initialCalories: widget.initialCalories,
            initialFat: widget.initialFat,
            initialCarbs: widget.initialCarbs,
            initialProtein: widget.initialProtein,
            onChange: widget.onChange,
          ),
        ],
      ),
    );
  }
}

class _FormWidget extends StatefulWidget {
  const _FormWidget({
    this.onChange,
    this.initialServingQuantity,
    this.initialUnit,
    this.initialWeightValue,
    this.initialWeightSymbol,
    this.initialCalories,
    this.initialFat,
    this.initialCarbs,
    this.initialProtein,
  });

  final double? initialServingQuantity;
  final String? initialUnit;
  final double? initialWeightValue;
  final String? initialWeightSymbol;
  final Unit? initialCalories;
  final Unit? initialFat;
  final Unit? initialCarbs;
  final Unit? initialProtein;
  final OnChangeRequiredNutritionFacts? onChange;

  @override
  State<_FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<_FormWidget> {

  List<DropdownMenuEntry<String>> _unitDropdownEntries = [];


  List<DropdownMenuEntry<String>> _getDefaultUnitsDropDownEntries(
          BuildContext context) =>
      [
        DropdownMenuEntry(
          value: context.localization?.serving ?? '',
          label: context.localization?.serving?.toUpperCaseWord ?? '',
        ),
        DropdownMenuEntry(
          value: context.localization?.piece ?? '',
          label: context.localization?.piece?.toUpperCaseWord ?? '',
        ),
        DropdownMenuEntry(
          value: context.localization?.cup ?? '',
          label: context.localization?.cup?.toUpperCaseWord ?? '',
        ),
        DropdownMenuEntry(
          value: context.localization?.oz ?? '',
          label: context.localization?.oz?.toUpperCaseWord ?? '',
        ),
        DropdownMenuEntry(
          value: context.localization?.gram ?? '',
          label: context.localization?.gram ?? '',
        ),
        DropdownMenuEntry(
          value: context.localization?.ml ?? '',
          label: context.localization?.ml ?? '',
        ),
        DropdownMenuEntry(
          value: context.localization?.handful ?? '',
          label: context.localization?.handful?.toUpperCaseWord ?? '',
        ),
        DropdownMenuEntry(
          value: context.localization?.scoop ?? '',
          label: context.localization?.scoop?.toUpperCaseWord ?? '',
        ),
        DropdownMenuEntry(
          value: context.localization?.tbsp ?? '',
          label: context.localization?.tbsp?.toUpperCaseWord ?? '',
        ),
        DropdownMenuEntry(
          value: context.localization?.tsp ?? '',
          label: context.localization?.tsp?.toUpperCaseWord ?? '',
        ),
        DropdownMenuEntry(
          value: context.localization?.slice ?? '',
          label: context.localization?.slice?.toUpperCaseWord ?? '',
        ),
        DropdownMenuEntry(
          value: context.localization?.can ?? '',
          label: context.localization?.can?.toUpperCaseWord ?? '',
        ),
        DropdownMenuEntry(
          value: context.localization?.bottle ?? '',
          label: context.localization?.bottle?.toUpperCaseWord ?? '',
        ),
        DropdownMenuEntry(
          value: context.localization?.bar ?? '',
          label: context.localization?.bar?.toUpperCaseWord ?? '',
        ),
        DropdownMenuEntry(
          value: context.localization?.packet ?? '',
          label: context.localization?.packet?.toUpperCaseWord ?? '',
        ),
        DropdownMenuEntry(
          value: context.localization?.small ?? '',
          label: context.localization?.small?.toUpperCaseWord ?? '',
        ),
        DropdownMenuEntry(
          value: context.localization?.medium ?? '',
          label: context.localization?.medium?.toUpperCaseWord ?? '',
        ),
        DropdownMenuEntry(
          value: context.localization?.large ?? '',
          label: context.localization?.large?.toUpperCaseWord ?? '',
        ),
      ];

  final _servingQuantityController = TextEditingController();
  final _weightController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _fatController = TextEditingController();
  final _carbsController = TextEditingController();
  final _proteinController = TextEditingController();

  String? _selectedUnit;

  // Value Notifier
  final ValueNotifier<bool> _visibleWeight = ValueNotifier(true);
  final ValueNotifier<String?> _selectedWeightSymbol =
      ValueNotifier(UnitMassType.grams.symbol);

  List<DropdownMenuItem<String>> _getWeightDropDownEntries(
          BuildContext context) =>
      [
        DropdownMenuItem(
          value: context.localization?.ml ?? '',
          child: Text(context.localization?.ml ?? ''),
        ),
        DropdownMenuItem(
          value: context.localization?.g ?? '',
          child: Text(context.localization?.g ?? ''),
        ),
      ];

  final _servingQuantityFocusNode = FocusNode();
  final _weightFocusNode = FocusNode();
  final _caloriesFocusNode = FocusNode();
  final _fatFocusNode = FocusNode();
  final _carbsFocusNode = FocusNode();
  final _proteinFocusNode = FocusNode();

  void _handleOnChange() {
    widget.onChange?.call(
      double.tryParse(_servingQuantityController.text)?.parseFormatted(places: 2),
      _selectedUnit,
      double.tryParse(_weightController.text)?.parseFormatted(places: 2),
      _selectedWeightSymbol.value,
      double.tryParse(_caloriesController.text) != null
          ? UnitEnergy(
              double.tryParse(_caloriesController.text)?.parseFormatted(places: 2) ?? 0,
              UnitEnergyType.kilocalories,
            )
          : null,
      double.tryParse(_fatController.text) != null
          ? UnitMass(
              double.tryParse(_fatController.text)?.parseFormatted(places: 2) ?? 0,
              UnitMassType.grams,
            )
          : null,
      double.tryParse(_carbsController.text) != null
          ? UnitMass(
              double.tryParse(_carbsController.text)?.parseFormatted(places: 2) ?? 0,
              UnitMassType.grams,
            )
          : null,
      double.tryParse(_proteinController.text) != null
          ? UnitMass(
              double.tryParse(_proteinController.text)?.parseFormatted(places: 2) ?? 0,
              UnitMassType.grams,
            )
          : null,
    );
  }

  void _setupListener(TextEditingController controller) {
    controller.addListener(() {
      _handleOnChange();
    });
  }

  @override
  void dispose() {
    // Controller
    _servingQuantityController.dispose();
    _weightController.dispose();
    _caloriesController.dispose();
    _fatController.dispose();
    _carbsController.dispose();
    _proteinController.dispose();

    // Focus Nodes
    _servingQuantityFocusNode.dispose();
    _weightFocusNode.dispose();
    _caloriesFocusNode.dispose();
    _fatFocusNode.dispose();
    _carbsFocusNode.dispose();
    _proteinFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    OkButtonWithKeyboard.setup(
      context: context,
      focusNode: _servingQuantityFocusNode,
    );
    OkButtonWithKeyboard.setup(
      context: context,
      focusNode: _weightFocusNode,
    );
    OkButtonWithKeyboard.setup(
      context: context,
      focusNode: _caloriesFocusNode,
    );
    OkButtonWithKeyboard.setup(
      context: context,
      focusNode: _fatFocusNode,
    );
    OkButtonWithKeyboard.setup(
      context: context,
      focusNode: _carbsFocusNode,
    );
    OkButtonWithKeyboard.setup(
      context: context,
      focusNode: _proteinFocusNode,
    );

    SchedulerBinding.instance.addPostFrameCallback((_) {
      _updateUnitsDropDownEntries();
      _servingQuantityController.text =
          widget.initialServingQuantity?.format(places: 2).toString() ?? '';
      _weightController.text =
          widget.initialWeightValue?.format(places: 2).toString() ?? '';
      _setServingUnit(widget.initialUnit, onChange: false);
      _caloriesController.text =
          widget.initialCalories?.value.format(places: 2).toString() ?? '';
      _fatController.text = widget.initialFat?.value.format(places: 2).toString() ?? '';
      _carbsController.text =
          widget.initialCarbs?.value.format(places: 2).toString() ?? '';
      _proteinController.text =
          widget.initialProtein?.value.format(places: 2).toString() ?? '';


      _setupListener(_servingQuantityController);
      _setupListener(_weightController);
      _setupListener(_caloriesController);
      _setupListener(_fatController);
      _setupListener(_carbsController);
      _setupListener(_proteinController);
    });

    super.initState();
  }

  void _updateUnitsDropDownEntries() {
    setState(() {
      _unitDropdownEntries = _getDefaultUnitsDropDownEntries(context);
      if(widget.initialUnit.isNotNullOrEmpty && !(_unitDropdownEntries.any((element) => element.value == widget.initialUnit))) {
        _unitDropdownEntries.insert(0, DropdownMenuEntry(
          value: widget.initialUnit ?? '',
          label: widget.initialUnit?.toUpperCaseWord ?? '',
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _NutritionFactField(
          title: context.localization?.servingQuantity ?? '',
          inputType: const TextInputType.numberWithOptions(decimal: true),
          focusNode: _servingQuantityFocusNode,
          inputFormatters: <TextInputFormatter>[
            TextInputFormatterUtil.decimalNumber
          ],
          controller: _servingQuantityController,
          isMandatory: true,
        ),
        _NutritionFactDropDown(
          title: context.localization?.servingUnit.toUpperCaseWord ?? '',
          initial: _selectedUnit,
          menuEntries: _unitDropdownEntries,
          onSelected: _setServingUnit,
          isMandatory: true,
        ),
        ValueListenableBuilder(
            valueListenable: _visibleWeight,
            builder: (context, value, child) {
              return value
                  ? ValueListenableBuilder(
                      valueListenable: _selectedWeightSymbol,
                      builder: (context, value, child) {
                        return _NutritionFactField(
                          title: context.localization?.weight.toUpperCaseWord ??
                              '',
                          inputType: const TextInputType.numberWithOptions(
                              decimal: true),
                          focusNode: _weightFocusNode,
                          inputFormatters: <TextInputFormatter>[
                            TextInputFormatterUtil.decimalNumber
                          ],
                          controller: _weightController,
                          isMandatory: true,
                          suffix: Padding(
                            padding: EdgeInsets.only(right: 8.w),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isDense: true,
                                borderRadius: BorderRadius.circular(8.r),
                                padding: EdgeInsets.zero,
                                dropdownColor: AppColors.white,
                                value: _selectedWeightSymbol.value,
                                items: _getWeightDropDownEntries(context),
                                style: AppTextStyle.textSm.addAll([
                                  AppTextStyle.textSm.leading5
                                ]).copyWith(color: AppColors.gray900),
                                onChanged: (String? value) {
                                  _selectedWeightSymbol.value = value;
                                  _handleOnChange();
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : const SizedBox.shrink();
            }),
        _NutritionFactField(
          title: context.localization?.calories ?? '',
          inputType: TextInputType.number,
          focusNode: _caloriesFocusNode,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
          controller: _caloriesController,
          suffix: SizedBox(
            width: 24.w,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                context.localization?.kcal ?? '',
                textAlign: TextAlign.center,
                style: AppTextStyle.textBase
                    .addAll([AppTextStyle.textBase.leading6]).copyWith(
                        color: AppColors.gray900),
              ),
            ),
          ),
          isMandatory: true,
        ),
        _NutritionFactField(
          title: context.localization?.fat ?? '',
          inputType: const TextInputType.numberWithOptions(decimal: true),
          focusNode: _fatFocusNode,
          inputFormatters: <TextInputFormatter>[
            TextInputFormatterUtil.decimalNumber
          ],
          controller: _fatController,
          suffix: SizedBox(
            width: 24.w,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                context.localization?.g ?? '',
                textAlign: TextAlign.center,
                style: AppTextStyle.textBase
                    .addAll([AppTextStyle.textBase.leading6]).copyWith(
                        color: AppColors.gray900),
              ),
            ),
          ),
          isMandatory: true,
        ),
        _NutritionFactField(
          title: context.localization?.carbs ?? '',
          inputType: const TextInputType.numberWithOptions(decimal: true),
          focusNode: _carbsFocusNode,
          inputFormatters: <TextInputFormatter>[
            TextInputFormatterUtil.decimalNumber
          ],
          controller: _carbsController,
          suffix: SizedBox(
            width: 24.w,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                context.localization?.g ?? '',
                textAlign: TextAlign.center,
                style: AppTextStyle.textBase
                    .addAll([AppTextStyle.textBase.leading6]).copyWith(
                        color: AppColors.gray900),
              ),
            ),
          ),
          isMandatory: true,
        ),
        _NutritionFactField(
          title: context.localization?.protein ?? '',
          inputType: const TextInputType.numberWithOptions(decimal: true),
          focusNode: _proteinFocusNode,
          inputFormatters: <TextInputFormatter>[
            TextInputFormatterUtil.decimalNumber
          ],
          controller: _proteinController,
          suffix: SizedBox(
            width: 24.w,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                context.localization?.g ?? '',
                textAlign: TextAlign.center,
                style: AppTextStyle.textBase
                    .addAll([AppTextStyle.textBase.leading6]).copyWith(
                        color: AppColors.gray900),
              ),
            ),
          ),
          isMandatory: true,
        ),
      ],
    );
  }

  void _setServingUnit(String? value, {bool onChange = true}) {
    _selectedUnit = value?.toLowerCase();

    _visibleWeight.value =
        (_selectedUnit != context.localization?.gram?.toLowerCase()) &&
            (_selectedUnit != context.localization?.ml);

    _weightController.text = _visibleWeight.value ? _weightController.text : '';

    if (_visibleWeight.value && _selectedWeightSymbol.value == null) {
      _selectedWeightSymbol.value = UnitMassType.grams.symbol;
    }
    _selectedWeightSymbol.value =
        _visibleWeight.value ? _selectedWeightSymbol.value : null;

    if(onChange) {
      _handleOnChange();
    } else {
      setState(() {
      });
    }
  }
}

class _NutritionFactField extends StatelessWidget {
  final String? title;
  final TextInputType inputType;
  final Widget? suffix;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final bool isMandatory;

  const _NutritionFactField({
    this.title,
    this.inputType = TextInputType.text,
    this.suffix,
    this.focusNode,
    this.inputFormatters,
    this.controller,
    this.isMandatory = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: title ?? '',
                    style: AppTextStyle.textSm.addAll([
                      AppTextStyle.textSm.leading5,
                      AppTextStyle.medium
                    ]).copyWith(color: AppColors.gray500),
                  ),
                  if(isMandatory)
                    TextSpan(
                      text: ' *',
                      style: AppTextStyle.textSm.addAll([
                        AppTextStyle.textSm.leading5,
                        AppTextStyle.medium
                      ]).copyWith(color: AppColors.red500),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: AppTextField(
              hintText: context.localization?.value?.toUpperCaseWord ?? '',
              hintStyle: AppTextStyle.textBase
                  .addAll([AppTextStyle.textBase.leading6]).copyWith(
                      color: AppColors.gray500),
              style: AppTextStyle.textBase
                  .addAll([AppTextStyle.textBase.leading6]).copyWith(
                      color: AppColors.gray900),
              keyboardType: inputType,
              suffixIcon: suffix,
              suffixIconConstraints:
                  BoxConstraints(maxHeight: 24.h, minWidth: 48.w),
              focusNode: focusNode,
              inputFormatters: inputFormatters,
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }
}

class _NutritionFactDropDown extends StatelessWidget {
  final String? title;
  final List<DropdownMenuEntry<String>> menuEntries;
  final ValueChanged<String?>? onSelected;
  final String? initial;
  final bool isMandatory;

  const _NutritionFactDropDown({
    required this.title,
    required this.menuEntries,
    this.initial,
    this.onSelected,
    this.isMandatory = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: title ?? '',
                    style: AppTextStyle.textSm.addAll([
                      AppTextStyle.textSm.leading5,
                      AppTextStyle.medium
                    ]).copyWith(color: AppColors.gray500),
                  ),
                  if(isMandatory)
                    TextSpan(
                      text: ' *',
                      style: AppTextStyle.textSm.addAll([
                        AppTextStyle.textSm.leading5,
                        AppTextStyle.medium
                      ]).copyWith(color: AppColors.red500),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: AppDropDownMenu(
              hintText: context.localization?.value.toUpperCaseWord ?? '',
              initialSelection: initial,
              dropdownMenuEntries: menuEntries,
              onSelected: onSelected,
              shape: WidgetStateProperty.all(const RoundedRectangleBorder()),
              menuHeight: 300.h,
            ),
          ),
        ],
      ),
    );
  }
}
