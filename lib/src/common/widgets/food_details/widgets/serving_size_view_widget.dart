import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../constant/app_colors.dart';
import '../../../constant/app_images.dart';
import '../../../constant/dimens.dart';
import '../../../constant/styles.dart';
import '../../../util/context_extension.dart';
import '../../../util/double_extensions.dart';
import '../../../util/keyboard_extension.dart';
import '../../../util/string_extensions.dart';
import '../../custom_button.dart';
import '../bloc/food_details_bloc.dart';

typedef OnServingSizeChange = Function(PassioServingSize? servingSize);
typedef OnServingUnit = Function(PassioServingUnit? servingUnit);
typedef OnQuantityChange = Function(bool fromSlider, double value);
typedef OnTapCloseEdit = VoidCallback;

class ServingSizeViewWidget extends StatefulWidget {
  const ServingSizeViewWidget({
    required this.quantityController,
    required this.sliderData,
    this.selectedServingUnitName,
    this.servingUnits,
    this.onChangeServingUnit,
    this.computedWeight,
    this.onQuantityChange,
    this.servingSizes,
    this.selectedServingSize,
    this.onServingSizeChange,
    this.onTapCloseEdit,
    this.isCloseVisible = false,
    super.key,
  });

  // [_quantityController] is use to update and get the value from quantity text field.
  final TextEditingController quantityController;

  // [servingUnits] use to display all servingUnits in dialog.
  final List<PassioServingUnit>? servingUnits;

  // [selectedServingUnit] is use to display the current selected serving unit.
  final String? selectedServingUnitName;

  // [onChangeServingUnitKeepWeight] is use to get callback when serving unit changes.
  final OnServingUnit? onChangeServingUnit;

  // [computedWeight] is calculation of quantity and grams.
  final UnitMass? computedWeight;

  // [sliderValue] is defines the position of slider.
  // [sliderMaximum] is maximum value the user can select.
  final SliderData sliderData;

  /// [onQuantityChange] function will call when update the quantity from slider or text field.
  final OnQuantityChange? onQuantityChange;

  // [servingSize] use to display the serving sizes.
  final List<PassioServingSize>? servingSizes;

  // [onServingSizeChange] call when update the serving size.
  final OnServingSizeChange? onServingSizeChange;

  // [selectedServingSize] default null or if any serving size is selected then it contains the value.
  final PassioServingSize? selectedServingSize;

  // [isCloseVisible] then display the close button.
  final bool isCloseVisible;

  // [onTapCloseEdit]
  final OnTapCloseEdit? onTapCloseEdit;

  @override
  State<ServingSizeViewWidget> createState() => _ServingSizeViewWidgetState();
}

class _ServingSizeViewWidgetState extends State<ServingSizeViewWidget> {
  OverlayEntry? overlayEntry;

  final Map<String?, PlatformImage?> filteredFoodItemsImages = {};

  final FocusNode _quantityFocusNode = FocusNode();

  @override
  void initState() {
    _quantityFocusNode.addListener(() {
      if (_quantityFocusNode.hasFocus) {
        if (mounted) {
          _showOkButtonOverlay(context);
        }
      } else {
        _removeOkButtonOverlay();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.passioInset,
      surfaceTintColor: AppColors.passioInset,
      margin: EdgeInsets.symmetric(horizontal: Dimens.w4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Dimens.h16.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Dimens.h8.horizontalSpace,
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: IntrinsicWidth(
                        child: Container(
                          constraints: BoxConstraints(minWidth: Dimens.w50),
                          color: AppColors.passioLowContrast,
                          child: TextFormField(
                            maxLines: 1,
                            textAlign: TextAlign.end,
                            focusNode: _quantityFocusNode,
                            textInputAction: TextInputAction.done,
                            controller: widget.quantityController,
                            onTap: () {
                              widget.quantityController.clear();
                            },
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: Dimens.h4, horizontal: Dimens.w4),
                              isDense: true,
                              filled: true,
                              fillColor: AppColors.passioLowContrast,
                              border: InputBorder.none,
                            ),
                            style: AppStyles.style17.copyWith(),
                          ),
                        ),
                      ),
                    ),
                    Dimens.w4.horizontalSpace,
                    if ((widget.servingUnits)?.isNotEmpty ?? false)
                      Flexible(
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            context.hideKeyboard();
                            _showServingUnitsDialog();
                          },
                          child: Container(
                            height: Dimens.h34,
                            padding: EdgeInsets.symmetric(vertical: Dimens.h4, horizontal: Dimens.w16),
                            decoration: BoxDecoration(
                              color: AppColors.dropDownFieldColor,
                              borderRadius: BorderRadius.circular(Dimens.r8),
                            ),
                            child: Text(
                              "${widget.selectedServingUnitName?.toUpperCaseWord}",
                              style: AppStyles.style16,
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                    Dimens.w4.horizontalSpace,
                    if (widget.computedWeight?.value != null)
                      Flexible(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: Dimens.duration200),
                          child: Text(
                            "(${double.parse(widget.computedWeight?.value.removeDecimalZeroFormat ?? '0')} ${widget.computedWeight?.symbol})",
                            style: AppStyles.style16,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Visibility(
                visible: widget.isCloseVisible,
                child: GestureDetector(
                  onTap: widget.onTapCloseEdit,
                  behavior: HitTestBehavior.translucent,
                  child: SizedBox(
                    width: Dimens.r40,
                    height: Dimens.r40,
                    child: Center(
                      child: Image.asset(
                        AppImages.icCancelCircle,
                        width: Dimens.r24,
                        height: Dimens.r24,
                      ),
                    ),
                  ),
                ),
              ),
              Dimens.w8.horizontalSpace,
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: Theme(
              data: ThemeData(sliderTheme: SliderThemeData(tickMarkShape: SliderTickMarkShape.noTickMark)),
              child: Slider.adaptive(
                value: widget.sliderData.sliderValue,
                divisions: widget.sliderData.sliderStep.round(),
                max: widget.sliderData.sliderMax,
                min: widget.sliderData.sliderMin,
                activeColor: AppColors.customBase,
                onChanged: (value) => widget.onQuantityChange?.call(true, value),
              ),
            ),
          ),

          /// Here we are showing list of serving size in horizontal list.
          if ((widget.servingSizes ?? []).isNotEmpty)
            SizedBox(
              height: Dimens.h68,
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(12),
                scrollDirection: Axis.horizontal,
                itemCount: widget.servingSizes?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  final passioServingSize = widget.servingSizes?.elementAt(index);
                  return GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      widget.onServingSizeChange?.call(passioServingSize);
                    },
                    child: Theme(
                      data: Theme.of(context).copyWith(canvasColor: AppColors.passioLowContrast),
                      child: ChoiceChip(
                        label: Text(
                          "${passioServingSize?.quantity.removeDecimalZeroFormat} ${passioServingSize?.unitName ?? ''}",
                          style: AppStyles.style14.copyWith(fontWeight: FontWeight.w500),
                        ),
                        selected: (widget.selectedServingSize?.quantity == passioServingSize?.quantity &&
                            widget.selectedServingSize?.unitName == passioServingSize?.unitName),
                        selectedColor: AppColors.passioMedContrast,
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(width: Dimens.w8);
                },
              ),
            ),
        ],
      ),
    );
  }

  void _showOkButtonOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(
      builder: (overlayContext) {
        return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: SizedBox(
            width: double.infinity,
            child: CustomElevatedButton(
              onTap: () {
                if (widget.quantityController.text.isNotEmpty) {
                  widget.onQuantityChange?.call(false, double.parse(widget.quantityController.text));
                } else {
                  widget.quantityController.text = widget.sliderData.sliderValue.removeDecimalZeroFormat.toString();
                }
                context.hideKeyboard();
              },
              text: context.localization?.ok ?? '',
            ),
          ),
        );
      },
    );

    overlayState.insert(overlayEntry!);
  }

  void _removeOkButtonOverlay() {
    if (overlayEntry != null) {
      overlayEntry?.remove();
      overlayEntry = null;
    }
  }

  void _showServingUnitsDialog() {
    int selectedServingUnitIndex = 0;
    if (widget.selectedServingUnitName != null) {
      selectedServingUnitIndex = widget.servingUnits?.indexWhere((element) => element.unitName == widget.selectedServingUnitName) ?? 0;
    }
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          height: 200,
          width: 200,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.quantityFieldColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Expanded(
                child: CupertinoPicker(
                  squeeze: 1.2,
                  useMagnifier: false,
                  scrollController: FixedExtentScrollController(initialItem: selectedServingUnitIndex),
                  onSelectedItemChanged: (int selectedItem) {
                    selectedServingUnitIndex = selectedItem;
                  },
                  itemExtent: 24,
                  children: widget.servingUnits
                          ?.map(
                            (e) => Text(
                              e.unitName.toCapitalized() ?? '',
                              style: AppStyles.style18,
                            ),
                          )
                          .toList() ??
                      [],
                ),
              ),
              CustomElevatedButton(
                onTap: () {
                  Navigator.pop(dialogContext);
                  widget.onChangeServingUnit?.call(widget.servingUnits?.elementAt(selectedServingUnitIndex));
                },
                text: context.localization?.select ?? '',
              )
            ],
          ),
        ),
      ),
    );
  }
}
