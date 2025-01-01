import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/constant/app_constants.dart';
import '../../../../../common/constant/app_padding.dart';
import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/models/food_item_model.dart';
import '../../../../../common/models/macro_item_model.dart';
import '../../../../../common/widgets/checkbox/primary_check_box.dart';
import 'macros_values_widget.dart';
import '../../../../../common/widgets/passio/food_item_row.dart';

class FoodItemWidget extends StatelessWidget {
  const FoodItemWidget({
    required this.foodItemModel,
    this.initialSelection = false,
    this.onChangeSelection,
    this.onTap,
    super.key,
  });

  final FoodItemModel foodItemModel;
  final bool initialSelection;
  final ValueChanged<bool>? onChangeSelection;
  final VoidCallback? onTap;

  List<MacroItemModel> _getMacros(BuildContext context) => [
        MacroItemModel(
          value: foodItemModel.calories.toDouble(),
          label: context.localization.cal ?? '',
          color: AppColors.yellow500,
        ),
        MacroItemModel(
          value: foodItemModel.carbs,
          label: context.localization.g ?? '',
          color: AppColors.lBlue500Normal,
        ),
        MacroItemModel(
          value: foodItemModel.calories.toDouble(),
          label: context.localization.g ?? '',
          color: AppColors.green500Success,
        ),
        MacroItemModel(
          value: foodItemModel.calories.toDouble(),
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
        padding: AppPadding.pa8,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8.h,
                children: [
                  FoodItemRow(
                    iconId: foodItemModel.iconId,
                    title: foodItemModel.title,
                    subtitle: foodItemModel.subtitle,
                  ),
                  MacrosValuesWidget(
                    macros: _getMacros(context),
                  ),
                ],
              ),
            ),
            8.horizontalSpace,
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
