import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constant/app_text_styles.dart';
import '../../extension/context_extension.dart';
import '../../extension/string_extensions.dart';
import '../../models/key_value_model.dart';
import '../../models/slider_data.dart';
import '../../util/double_extensions.dart';
import '../drop_down/secondary_dropdown.dart';
import '../slider/primary_slider.dart';
import '../text_input/number_text_input.dart';

class ServingSizeWidget extends StatefulWidget {
  final double initialQuantity;
  final String initialUnit;
  final List<String> units;
  final ValueChanged<ServingSize> onServingSizeChanged;

  const ServingSizeWidget({
    required this.initialQuantity,
    required this.initialUnit,
    required this.units,
    required this.onServingSizeChanged,
    super.key,
  });

  @override
  ServingSizeWidgetState createState() => ServingSizeWidgetState();
}

class ServingSizeWidgetState extends State<ServingSizeWidget> {
  late double _quantity;
  late String _unit;
  late TextEditingController _quantityController;
  late SliderData _sliderData;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
    _unit = widget.initialUnit;
    _quantityController = TextEditingController(text: _quantity.format());
    _sliderData = SliderData().updateSliderData(_unit, _quantity);
  }

  @override
  void didUpdateWidget(covariant ServingSizeWidget oldWidget) {
    // Check if the quantity has changed
    if (oldWidget.initialQuantity != widget.initialQuantity) {
      _quantity = widget.initialQuantity;
      _quantityController.text = _quantity.format();
      _sliderData = _sliderData.updateSliderData(_unit, _quantity);
    }

    // Check if the unit has changed
    if (oldWidget.initialUnit != widget.initialUnit) {
      _unit = widget.initialUnit;
      _sliderData = _sliderData.updateSliderData(_unit, _quantity);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.localization.servingSize ?? '',
          style: AppTextStyle.textBase
              .addAll([AppTextStyle.textBase.leading6, AppTextStyle.semiBold]),
        ),
        Row(
          spacing: 8.w,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 32.w,
                maxWidth: 64.w,
              ),
              child: NumberTextInput(
                controller: _quantityController,
                initialValue: _quantityController.text,
                hintText: '',
                isDense: true,
                textAlign: TextAlign.center,
                onFieldSubmitted: (value) {
                  final newQuantity = double.tryParse(value);
                  if (newQuantity != null) {
                    _quantity = newQuantity;
                    widget.onServingSizeChanged(
                        ServingSize(quantity: _quantity, unit: _unit));
                  }
                },
              ),
            ),
            Expanded(
              child: SecondaryDropdown<String>(
                value: KeyValueModel(text: _unit.toUpperCaseWord, value: _unit),
                options: widget.units.map((e) {
                  return KeyValueModel(value: e, text: e.toUpperCaseWord);
                }).toList(),
                onSelected: (value) {
                  if (value != null) {
                    if(value.value == 'gram') {
                      _quantity = 100;
                    } else {
                      _quantity = 1;
                    }
                    _quantityController.text = _quantity.format();
                    _sliderData = _sliderData.updateSliderData(_unit, _quantity);
                    setState(() {
                      _unit = value.value;
                    });
                    widget.onServingSizeChanged(
                        ServingSize(quantity: _quantity, unit: _unit));
                  }
                },
              ),
            ),
          ],
        ),
        PrimarySlider(
          min: _sliderData.minSlider,
          max: _sliderData.maxSlider,
          value: _quantity,
          divisions: _sliderData.divisions,
          onChanged: (newQuantity) {
            if (_sliderData.minSlider != newQuantity) {
              _quantity = newQuantity.parseFormatted();
            }
            setState(() {
              _quantity = newQuantity;
            });

            _quantityController.text = _quantity.format();
            widget.onServingSizeChanged(
                ServingSize(quantity: _quantity, unit: _unit));
          },
        ),
      ],
    );
  }
}

class ServingSize {
  final double quantity;
  final String unit;

  ServingSize({required this.quantity, required this.unit});
}
