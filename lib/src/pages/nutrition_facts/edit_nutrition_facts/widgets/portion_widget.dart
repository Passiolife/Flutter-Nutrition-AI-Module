import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/extension/context_extension.dart';
import '../../../../common/extension/string_extensions.dart';
import '../../../../common/models/key_value_model.dart';
import '../../../../common/widgets/drop_down/secondary_dropdown.dart';
import '../../../../common/widgets/text_input/number_text_input.dart';

class PortionWidget extends StatefulWidget {
  const PortionWidget({
    // this.servingController,
    // this.weightController,
    this.initialSelectedQuantity,
    this.initialSelectedUnit,
    this.units = const [],
    this.initialWeight,
    super.key,
  });

  final String? initialSelectedQuantity;
  final String? initialSelectedUnit;
  final List<String> units;

  // final TextEditingController? servingController;
  // final TextEditingController? weightController;

  final String? initialWeight;

  @override
  State<PortionWidget> createState() => _PortionWidgetState();
}

class _PortionWidgetState extends State<PortionWidget> {

  late TextEditingController _servingController;
  late TextEditingController _weightController;

  @override
  void initState() {
    _servingController =
        TextEditingController(text: widget.initialSelectedQuantity);
    _weightController =
        TextEditingController(text: widget.initialWeight);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant PortionWidget oldWidget) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (oldWidget.initialSelectedQuantity != widget.initialSelectedQuantity) {
        _servingController.text = widget.initialSelectedQuantity ?? '';
      }
      if (oldWidget.initialWeight != widget.initialWeight) {
        _weightController.text = widget.initialWeight ?? '';
      }
    });
    super.didUpdateWidget(oldWidget);
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
              // onFieldSubmitted: (_) {
              //   widget.onChange?.call(
              //     double.tryParse(_servingController.text),
              //     double.tryParse(_weightController.text),
              //     _unit,
              //   );
              // },
              // unit: context.localization.cal
            ),
            _buildField(
              context: context,
              title: context.localization.weight ?? '',
              controller: _weightController,
              // onFieldSubmitted: (_) {
              //   widget.onChange?.call(
              //     double.tryParse(_servingController.text),
              //     double.tryParse(_weightController.text),
              //     _unit,
              //   );
              // },
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
                    height: 40.h,
                    value: KeyValueModel(
                        text: widget.initialSelectedUnit?.toUpperCaseWord ?? '', value: widget.initialSelectedUnit ?? ''),
                    options: widget.units.map((e) {
                      return KeyValueModel(value: e, text: e.toUpperCaseWord);
                    }).toList(),
                    onSelected: (value) {
                      // if (value != null) {
                      //   setState(() {
                      //     _unit = value.value;
                      //   });
                      //   widget.onChange?.call(
                      //     double.tryParse(_servingController.text),
                      //     double.tryParse(_weightController.text),
                      //     _unit,
                      //   );
                      // }
                    },
                  ),
                ],
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
    String? suffix,
    TextEditingController? controller,
    Function(String)? onFieldSubmitted,
  }) {
    return Expanded(
      flex: flex,
      child: Column(
        spacing: 8.w,
        children: [
          Text(
            title,
            style: AppTextStyle.textSm.addAll(
                [AppTextStyle.textSm.leading4, AppTextStyle.medium]).copyWith(
              color: context.textThemeColors.brandTextLight,
            ),
          ),
          NumberTextInput(
            isDense: true,
            hintText: '-',
            contentPadding: AppPadding.pv8,
            textAlign: TextAlign.center,
            controller: controller,
            errorStyle: TextStyle(height: 0.01),
            autoValidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              return value.isNotNullOrEmpty ? null : '';
            },
            onFieldSubmitted: onFieldSubmitted,
            // suffix: Text(
            //   unit ?? '',
            //   style: AppTextStyle.textSm.addAll(
            //       [AppTextStyle.textSm.leading4, AppTextStyle.medium]).copyWith(
            //     color: context.textThemeColors.brandTextLight,
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}
