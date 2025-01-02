import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/constant/app_constants.dart';
import '../../../../../common/constant/app_padding.dart';
import '../../../../../common/extension/context_extension.dart';
import '../../../../../common/models/food_record/food_record.dart';
import '../../../../../common/models/macro_item_model.dart';
import '../../../../../common/widgets/checkbox/primary_check_box.dart';
import '../../models/take_photo_result_view_model.dart';
import 'macros_values_widget.dart';
import '../../../../../common/widgets/passio/food_item_row.dart';

class FoodItemWidget extends StatelessWidget {
  const FoodItemWidget({
    required this.viewModel,
    this.initialSelection = false,
    this.onChangeSelection,
    this.onTap,
    this.index,
    super.key,
  });

  final TakePhotoResultViewModel viewModel;
  final bool initialSelection;
  final ValueChanged<bool>? onChangeSelection;
  final VoidCallback? onTap;
  final int? index;

  List<MacroItemModel> _getMacros(BuildContext context) => [
        MacroItemModel(
          value: viewModel.foodRecord.totalCalories,
          label: context.localization.cal ?? '',
          color: AppColors.yellow500,
        ),
        MacroItemModel(
          value: viewModel.foodRecord.totalCarbs,
          label: context.localization.g ?? '',
          color: AppColors.lBlue500Normal,
        ),
        MacroItemModel(
          value: viewModel.foodRecord.totalProteins,
          label: context.localization.g ?? '',
          color: AppColors.green500Success,
        ),
        MacroItemModel(
          value: viewModel.foodRecord.totalFat,
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
                    iconId: viewModel.foodRecord.iconId,
                    index: index,
                    title: viewModel.title,
                    subtitle: viewModel.subtitle,
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
