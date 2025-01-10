import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/constant/app_constants.dart';
import '../../../../../common/constant/app_padding.dart';
import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/models/macro_item_model.dart';
import '../../../../../common/widgets/checkbox/primary_check_box.dart';
import 'macros_values_widget.dart';
import '../../../../../common/widgets/passio/food_item_row.dart';

class FoodItemWidget extends StatelessWidget {
  const FoodItemWidget({
    required this.iconId,
    required this.title,
    required this.subtitle,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    this.initialSelection = false,
    this.onChangeSelection,
    this.onTap,
    this.index,
    super.key,
  });

  final String iconId, title, subtitle;
  final double calories, carbs, protein, fat;
  final bool initialSelection;
  final ValueChanged<bool>? onChangeSelection;
  final VoidCallback? onTap;
  final int? index;

  List<MacroItemModel> _getMacros(BuildContext context) => [
        MacroItemModel(
          value: calories.round(),
          label: context.localization.cal ?? '',
          color: AppColors.yellow500,
        ),
        MacroItemModel(
          value: carbs,
          label: context.localization.g ?? '',
          color: AppColors.lBlue500Normal,
        ),
        MacroItemModel(
          value: protein,
          label: context.localization.g ?? '',
          color: AppColors.green500Success,
        ),
        MacroItemModel(
          value: fat,
          label: context.localization.g ?? '',
          color: AppColors.purple500,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        decoration: AppShadows.base,
        margin: AppPadding.ph16,
        padding: AppPadding.pl8 + AppPadding.pt8 + AppPadding.pb8,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.h,
                children: [
                  FoodItemRow(
                    iconId: iconId,
                    index: index,
                    title: title,
                    subtitle: subtitle,
                  ),
                  MacrosValuesWidget(
                    macros: _getMacros(context),
                  ),
                ],
              ),
            ),
            PrimaryCheckBox(
              isSelected: initialSelection,
              onChanged: onChangeSelection,
            ),
          ],
        ),
      ),
    );
  }
}
