import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/extension/core_extension.dart';

class WaterRowWidget extends StatelessWidget {
  const WaterRowWidget({
    required this.value,
    required this.unit,
    required this.date,
    required this.time,
    this.onDelete,
    this.onEdit,
    super.key,
  });

  final String value;
  final String unit;
  final String date;
  final String time;
  // If the value is true, then ask confirmation to delete the item.
  final ValueChanged<bool>? onDelete;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: UniqueKey(),
      // The end action pane is the one at the right or the bottom side.
      endActionPane: ActionPane(
        extentRatio: 0.6,
        motion: const DrawerMotion(),
        dismissible: DismissiblePane(
          onDismissed: () => onDelete?.call(false),
        ),
        children: [
          SlidableAction(
            onPressed: (_) => onEdit?.call(),
            backgroundColor: AppColors.indigo600Main,
            foregroundColor: Colors.white,
            label: context.localization.edit,
          ),
          SlidableAction(
            autoClose: false,
            onPressed: (_) => onDelete?.call(true),
            backgroundColor: AppColors.red500,
            foregroundColor: Colors.white,
            label: context.localization.delete,
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.w8,
          vertical: AppDimens.h8,
        ),
        child: ListTile(
          onTap: onEdit,
          dense: true,
          minVerticalPadding: 0,
          contentPadding: EdgeInsets.only(
            left: AppDimens.w8,
            right: AppDimens.w16,
          ),
          title: RichText(
            text: TextSpan(
              text: value,
              style: AppTextStyle.textSm.addAll([
                AppTextStyle.textSm.leading5,
                AppTextStyle.semiBold
              ]).copyWith(
                color: AppColors.gray900,
              ),
              children: [
                TextSpan(
                  text: ' $unit',
                  style: AppTextStyle.textSm
                      .addAll([AppTextStyle.textSm.leading5]).copyWith(
                    color: AppColors.gray500,
                  ),
                ),
              ],
            ),
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                date,
                style: AppTextStyle.textSm
                    .addAll([AppTextStyle.textSm.leading5]).copyWith(
                        color: AppColors.gray900),
              ),
              Text(
                time,
                style: AppTextStyle.textSm
                    .addAll([AppTextStyle.textSm.leading5]).copyWith(
                        color: AppColors.gray900),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
