import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/dialogs/ok_button_with_keyboard.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/double_extensions.dart';
import '../../../common/util/string_extensions.dart';
import '../../../common/widgets/app_text_field.dart';
import 'interfaces.dart';
import 'typedefs.dart';

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class ServingSizeKey {
  final List<PassioServingUnit> servingUnits;
  final String? selectedServingUnit;

  const ServingSizeKey({
    required this.servingUnits,
    required this.selectedServingUnit,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ServingSizeKey &&
        listEquals(other.servingUnits, servingUnits) &&
        other.selectedServingUnit == selectedServingUnit;
  }

  @override
  int get hashCode => Object.hash(
        servingUnits,
        selectedServingUnit,
      );
}

class ServingSizeWidget extends StatefulWidget {
  ServingSizeWidget({
    this.servingSize,
    this.servingUnits = const [],
    this.selectedServingUnit,
    this.selectedQuantity = 1,
    this.sliderData,
    this.listener,
  }) : super(
            key: ValueKey(ServingSizeKey(
                selectedServingUnit: selectedServingUnit,
                servingUnits: servingUnits)));

  final List<PassioServingUnit> servingUnits;
  final SliderData? sliderData;
  final double selectedQuantity;
  final String? selectedServingUnit;
  final EditFoodListener? listener;
  final UnitMass? servingSize;

  @override
  State<ServingSizeWidget> createState() => _ServingSizeWidgetState();
}

class _ServingSizeWidgetState extends State<ServingSizeWidget> {
  double _selectedQuantity = 1;
  String? _selectedUnit;
  final TextEditingController _quantityController = TextEditingController();

  final FocusNode _quantityFocusNode = FocusNode();
  OkButtonWithKeyboard? _okButtonWithKeyboard;

  @override
  void initState() {
    _updateQuantityFromWidget();
    _updateUnitFromWidget();
    _quantityFocusNode.addListener(_handleFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _quantityFocusNode.removeListener(_handleFocusChange);
    _okButtonWithKeyboard?.hide();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      padding: EdgeInsets.only(
        left: AppDimens.r16,
        top: AppDimens.r16,
        right: AppDimens.r16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: context.localization?.servingSize,
              style: AppTextStyle.textBase.addAll([
                AppTextStyle.textBase.leading6,
                AppTextStyle.semiBold
              ]).copyWith(
                color: AppColors.gray900,
              ),
              children: [
                TextSpan(
                  text:
                      ' (${widget.servingSize?.value.formatNumber(places: 0) ?? 0} ${widget.servingSize?.symbol})',
                  style: AppTextStyle.textBase
                      .addAll([AppTextStyle.textBase.leading6]).copyWith(
                    color: AppColors.gray900,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppDimens.h16),
          Row(
            children: [
              AppTextField(
                width: AppDimens.r64,
                height: AppDimens.h42,
                controller: _quantityController,
                textAlign: TextAlign.center,
                focusNode: _quantityFocusNode,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
              ),
              SizedBox(width: AppDimens.w8),
              Expanded(
                child: Container(
                  constraints: BoxConstraints(maxHeight: AppDimens.h42),
                  child: Theme(
                    data: ThemeData(
                      dropdownMenuTheme: DropdownMenuThemeData(
                        textStyle: AppTextStyle.textBase
                            .copyWith(color: AppColors.gray900),
                        inputDecorationTheme: InputDecorationTheme(
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: AppDimens.w12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppDimens.r6),
                            borderSide:
                                const BorderSide(color: AppColors.gray300),
                          ),
                        ),
                        menuStyle: MenuStyle(
                          backgroundColor:
                              MaterialStateProperty.all(AppColors.white),
                          surfaceTintColor:
                              MaterialStateProperty.all(AppColors.white),
                        ),
                      ),
                    ),
                    child: SizedBox(
                      height: AppDimens.r64,
                      child: DropdownMenu<PassioServingUnit>(
                        menuHeight: AppDimens.h252,
                        expandedInsets: EdgeInsets.zero,
                        initialSelection: widget.servingUnits
                            .cast<PassioServingUnit?>()
                            .firstWhere(
                                (element) => element?.unitName == _selectedUnit,
                                orElse: () => null),
                        trailingIcon: SvgPicture.asset(
                          AppImages.icChevronDown,
                          width: AppDimens.r20,
                          height: AppDimens.r20,
                          colorFilter: const ColorFilter.mode(
                              AppColors.gray900, BlendMode.srcIn),
                        ),
                        selectedTrailingIcon: SvgPicture.asset(
                          AppImages.icChevronUp,
                          width: AppDimens.r20,
                          height: AppDimens.r20,
                          colorFilter: const ColorFilter.mode(
                              AppColors.gray900, BlendMode.srcIn),
                        ),
                        dropdownMenuEntries: widget.servingUnits
                            .map((e) => DropdownMenuEntry(
                                value: e, label: e.unitName.toUpperCaseWord))
                            .toList(),
                        onSelected: (value) {
                          setState(() {
                            _selectedUnit = value?.unitName;
                            widget.listener
                                ?.onChangeServingUnit(_selectedUnit ?? '');
                            // dropdownValue = value!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppDimens.h16),
          Theme(
            data: ThemeData(
              sliderTheme: SliderThemeData(
                trackHeight: AppDimens.h8,
                activeTrackColor: AppColors.indigo600Main,
                inactiveTrackColor: AppColors.indigo50,
                thumbColor: AppColors.indigo600Main,
                valueIndicatorColor: AppColors.indigo600Main,
                valueIndicatorTextStyle:
                    AppTextStyle.textXs.copyWith(color: AppColors.white),
                trackShape: const _CustomTrackShape(),
                tickMarkShape: SliderTickMarkShape.noTickMark,
                thumbShape:
                    RoundSliderThumbShape(enabledThumbRadius: AppDimens.r12),
              ),
            ),
            child: Slider(
              value: _selectedQuantity,
              min: widget.sliderData?.minSlider ?? 0,
              max: widget.sliderData?.maxSlider ?? 1,
              divisions: widget.sliderData?.divisions ?? 10,
              onChanged: (value) {
                // setState(() {
                _selectedQuantity = value;
                _quantityController.text =
                    _selectedQuantity.formatNumber(places: 2);
                widget.listener?.onChangeServingQuantity(
                  double.parse(_quantityController.text).roundNumber(),
                  false,
                );
                // });
              },
            ),
          ),
        ],
      ),
    );
  }

  void _updateQuantityFromWidget() {
    _selectedQuantity = widget.selectedQuantity;
    _quantityController.text = _selectedQuantity.formatNumber(places: 2);
  }

  void _updateUnitFromWidget() {
    if (widget.selectedServingUnit != null) {
      _selectedUnit = widget.selectedServingUnit;
    }
  }

  void _handleFocusChange() {
    if (_quantityFocusNode.hasFocus) {
      if (mounted) {
        _okButtonWithKeyboard = OkButtonWithKeyboard.show(
          context: context,
          onTap: _handleOkButtonTap,
        );
      }
    } else {
      _handleOkButtonTap();
      _okButtonWithKeyboard?.hide();
      _okButtonWithKeyboard = null;
    }
  }

  void _handleOkButtonTap() {
    if (_quantityController.text.isNotEmpty) {
      _selectedQuantity = double.parse(_quantityController.text);
      widget.listener?.onChangeServingQuantity(
        double.parse(_quantityController.text).roundNumber(),
        true,
      );
    } else {
      // Restore previous quantity if text field is empty after OK is tapped
      _quantityController.text = _selectedQuantity.formatNumber(places: 2);
    }
  }
}

class _CustomTrackShape extends RoundedRectSliderTrackShape {
  const _CustomTrackShape();

  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = sliderTheme.trackHeight;
    final trackLeft = offset.dx;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
