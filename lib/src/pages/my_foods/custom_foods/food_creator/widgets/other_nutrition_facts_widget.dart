import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../nutrition_ai_module.dart';
import '../../../../../common/constant/app_constants.dart';
import '../../../../../common/dialogs/ok_button_with_keyboard.dart';
import '../../../../../common/util/context_extension.dart';
import '../../../../../common/util/string_extensions.dart';
import '../../../../../common/util/text_input_formatter_util.dart';
import '../../../../../common/widgets/app_drop_down_menu.dart';
import '../../../../../common/widgets/app_text_field.dart';
import '../models/nutrient.dart';

class OtherNutritionFactsWidget extends StatefulWidget {
  const OtherNutritionFactsWidget({
    this.satFatValue = '',
    this.transFatValue = '',
    this.cholesterolValue = '',
    this.sodiumValue = '',
    this.dietaryFiberValue = '',
    this.totalSugarsValue = '',
    this.addedSugarValue = '',
    this.vitaminDValue = '',
    this.calciumValue = '',
    this.potassiumValue = '',
    this.onChanged,
    super.key,
  });

  final String satFatValue;
  final String transFatValue;
  final String cholesterolValue;
  final String sodiumValue;
  final String dietaryFiberValue;
  final String totalSugarsValue;
  final String addedSugarValue;
  final String vitaminDValue;
  final String calciumValue;
  final String potassiumValue;

  final Function(List<Nutrient>)? onChanged;

  @override
  State<OtherNutritionFactsWidget> createState() =>
      _OtherNutritionFactsWidgetState();
}

class _OtherNutritionFactsWidgetState extends State<OtherNutritionFactsWidget> {
  List<Nutrient> _getNutrients() => [
        Nutrient(
          label: context.localization?.saturatedFat ?? '',
          type: UnitMassType.grams,
          value: widget.satFatValue,
        ),
        Nutrient(
          label: context.localization?.transFat ?? '',
          type: UnitMassType.grams,
          value: widget.transFatValue,
        ),
        Nutrient(
          label: context.localization?.cholesterol ?? '',
          type: UnitMassType.milligrams,
          value: widget.cholesterolValue,
        ),
        Nutrient(
          label: context.localization?.sodium ?? '',
          type: UnitMassType.milligrams,
          value: widget.sodiumValue,
        ),
        Nutrient(
          label: context.localization?.dietaryFiber ?? '',
          type: UnitMassType.grams,
          value: widget.dietaryFiberValue,
        ),
        Nutrient(
          label: context.localization?.totalSugars ?? '',
          type: UnitMassType.grams,
          value: widget.totalSugarsValue,
        ),
        Nutrient(
          label: context.localization?.addedSugar ?? '',
          type: UnitMassType.grams,
          value: widget.addedSugarValue,
        ),
        Nutrient(
          label: context.localization?.vitaminD ?? '',
          type: UnitMassType.micrograms,
          value: widget.vitaminDValue,
        ),
        Nutrient(
          label: context.localization?.calcium ?? '',
          type: UnitMassType.milligrams,
          value: widget.calciumValue,
        ),
        Nutrient(
          label: context.localization?.potassium ?? '',
          type: UnitMassType.milligrams,
          value: widget.potassiumValue,
        ),
      ]..removeWhere(
          (e) => _addedEntries.value.any((added) => added.label == e.label));

  final ValueNotifier<List<Nutrient>> _addedEntries = ValueNotifier([]);

  void _onEntriesChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(_addedEntries.value);
    }
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (widget.satFatValue.isNotEmpty) {
        _addedEntries.value.add(_getNutrients()
            .firstWhere((e) => e.label == context.localization?.saturatedFat));
      }
      if (widget.transFatValue.isNotEmpty) {
        _addedEntries.value.add(_getNutrients()
            .firstWhere((e) => e.label == context.localization?.transFat));
      }
      if (widget.cholesterolValue.isNotEmpty) {
        _addedEntries.value.add(_getNutrients()
            .firstWhere((e) => e.label == context.localization?.cholesterol));
      }
      if (widget.sodiumValue.isNotEmpty) {
        _addedEntries.value.add(_getNutrients()
            .firstWhere((e) => e.label == context.localization?.sodium));
      }
      if (widget.dietaryFiberValue.isNotEmpty) {
        _addedEntries.value.add(_getNutrients()
            .firstWhere((e) => e.label == context.localization?.dietaryFiber));
      }
      if (widget.totalSugarsValue.isNotEmpty) {
        _addedEntries.value.add(_getNutrients()
            .firstWhere((e) => e.label == context.localization?.totalSugars));
      }
      if (widget.addedSugarValue.isNotEmpty) {
        _addedEntries.value.add(_getNutrients()
            .firstWhere((e) => e.label == context.localization?.addedSugar));
      }
      if (widget.vitaminDValue.isNotEmpty) {
        _addedEntries.value.add(_getNutrients()
            .firstWhere((e) => e.label == context.localization?.vitaminD));
      }
      if (widget.calciumValue.isNotEmpty) {
        _addedEntries.value.add(_getNutrients()
            .firstWhere((e) => e.label == context.localization?.calcium));
      }
      if (widget.potassiumValue.isNotEmpty) {
        _addedEntries.value.add(_getNutrients()
            .firstWhere((e) => e.label == context.localization?.potassium));
      }
      _addedEntries.value = List.from(_addedEntries.value);
      _onEntriesChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      padding: EdgeInsets.all(16.r),
      child: ValueListenableBuilder(
          valueListenable: _addedEntries,
          builder: (notifierContext, value, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.localization?.otherNutritionFacts ?? '',
                  style: AppTextStyle.textBase.addAll([
                    AppTextStyle.textBase.leading6,
                    AppTextStyle.semiBold,
                  ]),
                ),
                16.verticalSpace,
                Column(
                  children: value
                      .asMap()
                      .map((index, e) {
                        final nutrient = value[index];
                        return MapEntry(
                          index,
                          _NutritionFactField(
                            key: ValueKey(nutrient.label),
                            title: nutrient.label,
                            initialValue: nutrient.value,
                            onDelete: () {
                              _addedEntries.value =
                                  List.from(_addedEntries.value)
                                    ..removeAt(index);
                              _onEntriesChanged();
                            },
                            onChanged: (newValue) {
                              _addedEntries
                                  .value = List.from(_addedEntries.value)
                                ..[index] = nutrient.copyWith(value: newValue);
                              _onEntriesChanged();
                            },
                            suffix: SizedBox(
                              width: 24.w,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  nutrient.type.symbol,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyle.textBase.addAll([
                                    AppTextStyle.textBase.leading6
                                  ]).copyWith(color: AppColors.gray900),
                                ),
                              ),
                            ),
                            inputFormatters: [
                              TextInputFormatterUtil.decimalNumber,
                            ],
                            inputType: const TextInputType.numberWithOptions(
                                decimal: true),
                          ),
                        );
                      })
                      .values
                      .toList(),
                ),
                16.verticalSpace,
                _getNutrients().isNotEmpty
                    ? AppDropDownMenu(
                        key: UniqueKey(),
                        dropdownMenuEntries: _getNutrients()
                            .map((e) =>
                                DropdownMenuEntry(value: e, label: e.label))
                            .toList(),
                        hintText: context.localization?.selectNutrient,
                        onSelected: (selectedValue) {
                          if (selectedValue != null &&
                              !_addedEntries.value.contains(selectedValue)) {
                            _addedEntries.value = List.from(_addedEntries.value)
                              ..add(selectedValue);
                            _onEntriesChanged();
                          }
                        },
                      )
                    : const SizedBox.shrink(),
                // _FormWidget(),
              ],
            );
          }),
    );
  }
}

class _NutritionFactField extends StatefulWidget {
  final String? title;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onDelete;
  final Widget? suffix;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType inputType;

  const _NutritionFactField({
    this.title,
    this.initialValue,
    this.onChanged,
    this.onDelete,
    this.suffix,
    this.inputFormatters,
    this.inputType = TextInputType.text,
    super.key,
  });

  @override
  State<_NutritionFactField> createState() => _NutritionFactFieldState();
}

class _NutritionFactFieldState extends State<_NutritionFactField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);

  final _focusNode = FocusNode();

  @override
  void initState() {
    _controller.addListener(() {
      if (widget.onChanged != null) {
        widget.onChanged!(_controller.text);
      }
    });
    OkButtonWithKeyboard.setup(context: context, focusNode: _focusNode);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              widget.title ?? '',
              style: AppTextStyle.textSm.addAll([
                AppTextStyle.textSm.leading5,
                AppTextStyle.medium
              ]).copyWith(color: AppColors.gray500),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: _controller,
                    onChanged: (newValue) {
                      if (widget.onChanged != null) {
                        widget.onChanged!(newValue);
                      }
                    },
                    hintText: context.localization?.value?.toUpperCaseWord,
                    suffixIcon: widget.suffix,
                    suffixIconConstraints:
                        BoxConstraints(maxHeight: 24.h, minWidth: 48.w),
                    focusNode: _focusNode,
                    inputFormatters: widget.inputFormatters,
                    keyboardType: widget.inputType,
                  ),
                ),
                IconButton(
                  icon: SvgPicture.asset(
                    AppImages.icTrash,
                    width: 24.r,
                    height: 24.r,
                  ),
                  onPressed: widget.onDelete,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
