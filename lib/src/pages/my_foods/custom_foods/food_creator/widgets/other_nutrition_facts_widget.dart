import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../view_models/food_creator_view_model.dart';

import '../../../../../../nutrition_ai_module.dart';
import '../../../../../common/constant/app_constants.dart';
import '../../../../../common/dialogs/ok_button_with_keyboard.dart';
import '../../../../../common/extension/number_extension.dart';
import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/util/double_extensions.dart';
import '../../../../../common/extension/string_extensions.dart' as string_extensions;
import '../../../../../common/util/text_input_formatter_util.dart';
import '../../../../../common/widgets/app_drop_down_menu.dart';
import '../../../../../common/widgets/app_text_field.dart';
import '../view_models/nutrient_view_model.dart';

class OtherNutritionFactsWidget extends StatefulWidget {
  const OtherNutritionFactsWidget({
    this.viewModel,
    this.onChanged,
    super.key,
  });

  final FoodCreatorViewModel? viewModel;

  final Function(List<NutrientViewModel>)? onChanged;

  @override
  State<OtherNutritionFactsWidget> createState() =>
      _OtherNutritionFactsWidgetState();
}

class _OtherNutritionFactsWidgetState extends State<OtherNutritionFactsWidget> {
  List<NutrientViewModel> _getNutrients() => [
        NutrientViewModel(
          label: context.localization?.saturatedFat ?? '',
          type: UnitMassType.grams,
          value: widget.viewModel?.satFat?.value.format(places: 2) ?? '',
        ),
        NutrientViewModel(
          label: context.localization?.transFat ?? '',
          type: UnitMassType.grams,
          value: widget.viewModel?.transFat?.value.format(places: 2) ?? '',
        ),
        NutrientViewModel(
          label: context.localization?.cholesterol ?? '',
          type: UnitMassType.milligrams,
          value: widget.viewModel?.cholesterol?.value.format(places: 2) ?? '',
        ),
        NutrientViewModel(
          label: context.localization?.sodium ?? '',
          type: UnitMassType.milligrams,
          value: widget.viewModel?.sodium?.value.format(places: 2) ?? '',
        ),
        NutrientViewModel(
          label: context.localization?.dietaryFiber ?? '',
          type: UnitMassType.grams,
          value: widget.viewModel?.dietaryFiber?.value.format(places: 2) ?? '',
        ),
        NutrientViewModel(
          label: context.localization?.totalSugars ?? '',
          type: UnitMassType.grams,
          value: widget.viewModel?.totalSugars?.value.format(places: 2) ?? '',
        ),
        NutrientViewModel(
          label: context.localization?.addedSugar ?? '',
          type: UnitMassType.grams,
          value: widget.viewModel?.addedSugars?.value.format(places: 2) ?? '',
        ),
        NutrientViewModel(
          label: context.localization?.vitaminD ?? '',
          type: UnitMassType.micrograms,
          value: widget.viewModel?.vitaminD?.value.format(places: 2) ?? '',
        ),
        NutrientViewModel(
          label: context.localization?.calcium ?? '',
          type: UnitMassType.milligrams,
          value: widget.viewModel?.calcium?.value.format(places: 2) ?? '',
        ),
        NutrientViewModel(
          label: context.localization?.potassium ?? '',
          type: UnitMassType.milligrams,
          value: widget.viewModel?.potassium?.value.format(places: 2) ?? '',
        ),
      ]..removeWhere(
          (e) => _addedEntries.value.any((added) => added.label == e.label));

  final ValueNotifier<List<NutrientViewModel>> _addedEntries =
      ValueNotifier([]);

  void _onEntriesChanged() {
    if (widget.onChanged != null) {
      widget.onChanged!(_addedEntries.value);
    }
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _addedEntries.value.addAll(_getNutrients()
          .where((e) => e.value.isNotEmpty)
          .map((e) => e)
          .toList());
      _addedEntries.value = List.from(_addedEntries.value);
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
                              final newDoubleValue = newValue.localeFormatted(places: 2);
                              if (newDoubleValue == null) {
                                return;
                              }
                              _addedEntries
                                  .value = List.from(_addedEntries.value)
                                ..[index] = nutrient.copyWith(
                                    value: newDoubleValue.toString());
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

  bool _isUpdatingController = false;

  @override
  void initState() {
    _controller.addListener(() {
      if (_isUpdatingController) {
        return; // Skip if we're updating the controller manually
      }
      if (widget.onChanged != null) {
        widget.onChanged!(_controller.text);
      }
    });
    OkButtonWithKeyboard.setup(
        context: context,
        focusNode: _focusNode,
        onTap: () {
          final newValue = double.tryParse(_controller.text);
          if (newValue == null) {
            return;
          }
          // Format the value and call the callback
          final formattedValue = newValue.format(places: 2);
          widget.onChanged!(formattedValue);

          // Temporarily disable the listener and update the controller
          _isUpdatingController = true;
          _controller.text = formattedValue;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: _controller.text.length),
          );
          _isUpdatingController = false;
        });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
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
                    hintText:
                        string_extensions.Util(context.localization?.value)
                            ?.toUpperCaseWord,
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
