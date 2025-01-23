import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/extension/context_extension.dart';
import '../../../../common/extension/string_extensions.dart';
import '../../../../common/formatter/single_decimal_formatter.dart';
import '../../../../common/widgets/text_input/number_text_input.dart';

class NutritionFactsWidget extends StatefulWidget {
  const NutritionFactsWidget({
    this.initialCalories,
    this.initialCarbs,
    this.initialProtein,
    this.initialFat,
    this.onChange,
    super.key,
  });

  final String? initialCalories;
  final String? initialCarbs;
  final String? initialProtein;
  final String? initialFat;
  final Function(double?, double?, double?, double?)? onChange;

  @override
  State<NutritionFactsWidget> createState() => _NutritionFactsWidgetState();
}

class _NutritionFactsWidgetState extends State<NutritionFactsWidget> {
  late TextEditingController _caloriesController;
  late TextEditingController _carbsController;
  late TextEditingController _proteinController;
  late TextEditingController _fatController;

  @override
  void initState() {
    _caloriesController = TextEditingController(text: widget.initialCalories);
    _carbsController = TextEditingController(text: widget.initialCarbs);
    _proteinController = TextEditingController(text: widget.initialProtein);
    _fatController = TextEditingController(text: widget.initialFat);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NutritionFactsWidget oldWidget) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (oldWidget.initialCalories != widget.initialCalories) {
        _caloriesController.text = widget.initialCalories ?? '';
      }
      if (oldWidget.initialCarbs != widget.initialCarbs) {
        _carbsController.text = widget.initialCarbs ?? '';
      }
      if (oldWidget.initialProtein != widget.initialProtein) {
        _proteinController.text = widget.initialProtein ?? '';
      }
      if (oldWidget.initialFat != widget.initialFat) {
        _fatController.text = widget.initialFat ?? '';
      }
    });

    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _caloriesController.dispose();
    _carbsController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16.h,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.localization.nutritionFacts ?? '',
          style: AppTextStyle.textBase
              .addAll([AppTextStyle.textBase.leading6, AppTextStyle.semiBold]),
        ),
        Row(
          spacing: 8.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField(
              context: context,
              title: context.localization.calories ?? '',
              controller: _caloriesController,
              unit: context.localization.cal,
              // onFieldSubmitted: (_) {
              //   widget.onChange.call(
              //     double.tryParse(_caloriesController.text),
              //     double.tryParse(_carbsController.text),
              //     double.tryParse(_proteinController.text),
              //     double.tryParse(_fatController.text),
              //   );
              // },
            ),
            _buildField(
              context: context,
              title: context.localization.carbs ?? '',
              controller: _carbsController,
              unit: context.localization.g,
              onFieldSubmitted: (_) {
                // widget.onChange.call(
                //   double.tryParse(_caloriesController.text),
                //   double.tryParse(_carbsController.text),
                //   double.tryParse(_proteinController.text),
                //   double.tryParse(_fatController.text),
                // );
              },
            ),
            _buildField(
              context: context,
              title: context.localization.protein ?? '',
              controller: _proteinController,
              unit: context.localization.g,
              onFieldSubmitted: (_) {
                // widget.onChange.call(
                //   double.tryParse(_caloriesController.text),
                //   double.tryParse(_carbsController.text),
                //   double.tryParse(_proteinController.text),
                //   double.tryParse(_fatController.text),
                // );
              },
            ),
            _buildField(
              context: context,
              title: context.localization.fat ?? '',
              controller: _fatController,
              unit: context.localization.g,
              onFieldSubmitted: (_) {
                // widget.onChange.call(
                //   double.tryParse(_caloriesController.text),
                //   double.tryParse(_carbsController.text),
                //   double.tryParse(_proteinController.text),
                //   double.tryParse(_fatController.text),
                // );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildField({
    required BuildContext context,
    required String title,
    String? unit,
    TextEditingController? controller,
    Function(String)? onFieldSubmitted,
  }) {
    return Expanded(
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
        inputFormatters: [
          const SingleDecimalFormatter(),
        ],
        onFieldSubmitted: onFieldSubmitted,
        suffixText: unit ?? '',
      ),
    );
  }
}
