import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/extension/core_extension.dart';
import '../../../common/models/key_value_model.dart';
import '../../../common/util/double_extensions.dart';
import '../../../common/widgets/drop_down/secondary_dropdown.dart';
import '../../../common/widgets/icons/trash_icon_widget.dart';
import '../../../common/widgets/text_input/number_text_input.dart';

class OtherNutritionFactsWidget extends StatelessWidget {
  const OtherNutritionFactsWidget({
    required this.hintText,
    required this.options,
    required this.selectedOptions,
    this.onSelected,
    this.onChangedOption,
    this.onDelete,
    super.key,
  });

  final List<KeyValueModel<UnitMass>> options;
  final String hintText;
  final ValueChanged<KeyValueModel<UnitMass>?>? onSelected;

  //
  final List<KeyValueModel<UnitMass>> selectedOptions;
  final ValueChanged<KeyValueModel<UnitMass>>? onChangedOption;

  final ValueChanged<KeyValueModel<UnitMass>?>? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      padding: AppPadding.pa16,
      margin: AppPadding.pt16 + AppPadding.ph16 + AppPadding.pb8,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              context.localization.otherNutritionFacts,
              style: AppTextStyle.textBase.addAll([
                AppTextStyle.textBase.leading6,
                AppTextStyle.semiBold,
              ]).copyWith(color: AppColors.black),
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: selectedOptions.length,
              padding: selectedOptions.isNotEmpty
                  ? AppPadding.pt16
                  : EdgeInsets.zero,
              separatorBuilder: (context, index) => 16.verticalSpace,
              itemBuilder: (context, index) {
                final model = selectedOptions[index];
                return _NutritionInputRow(
                  label: model.text,
                  hintText: context.localization.value.toUpperCaseWord,
                  initialValue: model.value.value >= 0
                      ? model.value.value.format()
                      : '',
                  onFieldSubmitted: (value) {
                    final KeyValueModel<UnitMass> newModel = model.copyWith(
                      value: UnitMass(double.parse(value), model.value.unit),
                    );
                    onChangedOption?.call(newModel);
                  },
                  onDelete: () => onDelete?.call(model),
                );
              },
            ),
            if (options.isNotEmpty) ...[
              16.verticalSpace,
              SecondaryDropdown(
                key: ObjectKey(options),
                hint: hintText,
                options: options,
                onSelected: onSelected,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _NutritionInputRow extends StatefulWidget {
  const _NutritionInputRow({
    required this.label,
    required this.hintText,
    this.initialValue,
    this.onFieldSubmitted,
    this.onDelete,
  });

  final String label;
  final String hintText;
  final String? initialValue;
  final ValueChanged<String>? onFieldSubmitted;
  final VoidCallback? onDelete;

  @override
  State<_NutritionInputRow> createState() => _NutritionInputRowState();
}

class _NutritionInputRowState extends State<_NutritionInputRow> {

  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void didUpdateWidget(covariant _NutritionInputRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (oldWidget.initialValue != widget.initialValue) {
        _controller.text = widget.initialValue ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.label,
            style: AppTextStyle.textSm.addAll([
              AppTextStyle.textSm.leading5,
              AppTextStyle.medium
            ]).copyWith(color: context.textThemeColors.brandTextLight),
          ),
        ),
        Expanded(
          flex: 2,
          child: NumberTextInput(
            hintText: widget.hintText,
            onFieldSubmitted: widget.onFieldSubmitted,
            controller: _controller,
          ),
        ),
        TrashIconWidget(
          color: context.iconThemeColors.brandIconLight!,
          onTap: widget.onDelete,
        ),
      ],
    );
  }
}
