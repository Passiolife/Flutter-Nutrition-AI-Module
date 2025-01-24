import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/extension/context_extension.dart';
import '../../../../common/extension/number_extension.dart';
import '../../../../common/extension/string_extensions.dart';
import '../../../../common/models/key_value_model.dart';
import '../../../../common/widgets/drop_down/secondary_dropdown.dart';
import '../../../../common/widgets/text_input/number_text_input.dart';

class PortionWidget extends StatefulWidget {
  const PortionWidget({
    this.initialSelectedQuantity,
    this.initialSelectedUnit,
    this.units = const [],
    this.initialWeight,
    this.onChange,
    super.key,
  });

  final String? initialSelectedQuantity;
  final String? initialSelectedUnit;
  final List<String> units;
  final String? initialWeight;

  final Function(double? quantity, String unit, double? weight)? onChange;

  @override
  State<PortionWidget> createState() => _PortionWidgetState();
}

class _PortionWidgetState extends State<PortionWidget> {
  late TextEditingController _servingController;
  late TextEditingController _weightController;
  late String _unit = widget.initialSelectedUnit ?? '';

  bool _shouldVisibleWeightField = true;

  @override
  void initState() {
    _servingController =
        TextEditingController(text: widget.initialSelectedQuantity);
    _weightController = TextEditingController(text: widget.initialWeight);

    _setListener();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PortionWidget oldWidget) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _removeListener();
      if (oldWidget.initialSelectedQuantity != widget.initialSelectedQuantity) {
        _servingController.text = widget.initialSelectedQuantity ?? '';
      }
      if (oldWidget.initialWeight != widget.initialWeight) {
        _weightController.text = widget.initialWeight ?? '';
      }
      if (oldWidget.initialSelectedUnit != widget.initialSelectedUnit) {
        setState(() {
          _unit = widget.initialSelectedUnit ?? '';
        });
      }
      _setListener();
    });
    super.didUpdateWidget(oldWidget);
  }

  void _setListener() {
    _servingController.addListener(_onFieldSubmitted);
    _weightController.addListener(_onFieldSubmitted);
  }

  void _removeListener() {
    _servingController.removeListener(_setListener);
    _weightController.removeListener(_setListener);
  }

  void _onFieldSubmitted() {
    String? serving = _servingController.text.localeFormatted().format();
    String? weight = _weightController.text.localeFormatted().format();

    if (widget.initialSelectedQuantity == serving &&
        widget.initialWeight == weight &&
        _unit == widget.initialSelectedUnit) {
      return;
    }

    _shouldVisibleWeightField = _unit != 'gram';

    widget.onChange?.call(
      (_servingController.text).localeFormatted(),
      _unit,
      (_weightController.text).localeFormatted(),
    );
  }

  @override
  void dispose() {
    _servingController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.localization.portions ?? '',
          style: AppTextStyle.textBase
              .addAll([AppTextStyle.textBase.leading6, AppTextStyle.semiBold]),
        ),
        Row(
          spacing: 8.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField(
              context: context,
              title: context.localization.serving.toUpperCaseWord,
              controller: _servingController,
              onFieldSubmitted: (value) {
                _onFieldSubmitted();
              },
            ),
            Expanded(
              flex: 3,
              child: Column(
                spacing: 8.w,
                children: [
                  Text(
                    context.localization.unit ?? '',
                    style: AppTextStyle.textSm.addAll([
                      AppTextStyle.textSm.leading4,
                      AppTextStyle.medium
                    ]).copyWith(
                      color: context.textThemeColors.brandTextLight,
                    ),
                  ),
                  SecondaryDropdown<String>(
                    height: 44.h,
                    value: KeyValueModel(
                        text: _unit.toUpperCaseWord, value: _unit),
                    options: widget.units.map((e) {
                      return KeyValueModel(value: e, text: e.toUpperCaseWord);
                    }).toList(),
                    onSelected: (value) {
                      if (value == null) return;
                      _unit = value.value;
                      _onFieldSubmitted();
                    },
                  ),
                ],
              ),
            ),
            Visibility(
              visible: _shouldVisibleWeightField,
              child: _buildField(
                context: context,
                title: context.localization.weight ?? '',
                controller: _weightController,
                onFieldSubmitted: (value) {
                  _onFieldSubmitted();
                },
                unit: context.localization.g,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildField({
    required BuildContext context,
    required String title,
    int flex = 1,
    String? unit,
    TextEditingController? controller,
    Function(String)? onFieldSubmitted,
  }) {
    return Expanded(
      flex: flex,
      child: NumberTextInput(
        isDense: true,
        labelText: title,
        labelAlignment: Alignment.center,
        hintText: '-',
        contentPadding: AppPadding.pv8 + AppPadding.ph8,
        textAlign: TextAlign.center,
        controller: controller,
        errorStyle: TextStyle(height: 0.01),
        autoValidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          return value.isNotNullOrEmpty ? null : '';
        },
        onFieldSubmitted: onFieldSubmitted,
        suffixText: unit ?? '',
        // suffix: Text(
        //   unit ?? '',
        //   style: AppTextStyle.textSm.addAll(
        //       [AppTextStyle.textSm.leading4, AppTextStyle.medium]).copyWith(
        //     color: context.textThemeColors.brandTextLight,
        //   ),
        // ),
      ),
    );
  }
}
