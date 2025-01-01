import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/constant/app_constants.dart';
import '../../../../../common/constant/app_padding.dart';
import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/models/food_record/meal_label.dart';
import '../../../../../common/models/key_value_model.dart';
import '../../../../../common/util/navigation_utils/hero_dialog_route.dart';
import '../../../../../common/widgets/button/primary_button.dart';
import '../../../../../common/widgets/button/secondary_button.dart';
import '../../../../../common/widgets/drop_down/secondary_dropdown.dart';
import '../../../../../common/widgets/passio/food_item_row.dart';
import '../../../../../common/widgets/slider/primary_slider.dart';
import '../../../../../common/widgets/text_input/number_text_input.dart';

class AdjustServingSize extends StatelessWidget {
  const AdjustServingSize({super.key});

  static void navigate({required BuildContext context}) {
    Navigator.push(
      context,
      HeroDialogRoute(
        child: AdjustServingSize(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: AppColors.transparent,
        child: Wrap(
          children: [
            Container(
              decoration: AppShadows.base,
              padding: AppPadding.pa16,
              margin: AppPadding.pa16,
              child: Column(
                spacing: 16.h,
                children: [
                  Text(
                    context.localization.adjustServingSize ?? '',
                    style: AppTextStyle.textXl.addAll([
                      AppTextStyle.textXl.leading7,
                      AppTextStyle.bold,
                    ]),
                  ),
                  FoodItemRow(
                    iconId: '',
                    title: 'Fried Egg',
                    subtitle: '2 Medium Eggs (92 g)',
                  ),
                  _ServingSizeWidget(),
                  _ActionButtons(
                    onCancel: () {
                      Navigator.pop(context);
                    },
                    onDone: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ServingSizeWidget extends StatefulWidget {
  const _ServingSizeWidget();

  @override
  State<_ServingSizeWidget> createState() => _ServingSizeWidgetState();
}

class _ServingSizeWidgetState extends State<_ServingSizeWidget> {
  KeyValueModel<String>? _selectedMealLabel;
  final List<KeyValueModel<String>> _mealTimes = MealLabel.values
      .map((e) => KeyValueModel(text: e.value, value: ''))
      .toList();

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
              child: NumberTextInput(hintText: ''),
            ),
            Expanded(
              child: SecondaryDropdown<String>(
                value: _selectedMealLabel,
                options: _mealTimes,
                onSelected: (value) {
                  if (value == null) return;
                  // widget.onSelected?.call(value);
                  setState(() {
                    _selectedMealLabel = value;
                  });
                },
              ),
            ),
          ],
        ),
        PrimarySlider(),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({this.onCancel, this.onDone});

  final VoidCallback? onCancel;
  final VoidCallback? onDone;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16.w,
      children: [
        Expanded(
          child: SecondaryButton(
            text: context.localization.cancel,
            onTap: onCancel,
          ),
        ),
        Expanded(
          child: PrimaryButton(
            text: context.localization.done,
            onTap: onDone,
          ),
        ),
      ],
    );
  }
}
