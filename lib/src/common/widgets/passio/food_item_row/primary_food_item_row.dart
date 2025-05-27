import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../constant/app_constants.dart';
import '../../../extension/core_extension.dart';
import '../../icons/plus_icon_widget.dart';
import '../../passio_image_widget_new.dart';
import 'base_food_item_row_new.dart';

class PrimaryFoodItemRow extends StatelessWidget {
  final Uint8List? image;
  final String iconId;
  final String title;
  final String subtitle;
  final int? index;
  final bool isLoading;
  final VoidCallback? onTap;
  final VoidCallback? onTapAdd;
  final Function(bool forced)? onTapDelete;
  final VoidCallback? onTapEdit;

  const PrimaryFoodItemRow({
    required this.iconId,
    required this.title,
    required this.subtitle,
    this.image,
    this.index,
    this.isLoading = false,
    this.onTap,
    this.onTapAdd,
    this.onTapDelete,
    this.onTapEdit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = context.theme.primaryColor;
    return BaseFoodItemRow(
      leading: PassioImageWidget(
        key: ValueKey('${image?.hashCode}-$iconId-$index'),
        image: image,
        iconId: iconId,
        heroTag: '$iconId $index',
        radius: 20.r,
      ),
      title: Hero(
        tag: '$title $index',
        child: Text(
          title,
          style: AppTextStyle.textSm
              .addAll([AppTextStyle.textSm.leading5, AppTextStyle.semiBold]),
        ),
      ),
      subtitle: Hero(
        tag: '$subtitle $index',
        child: Text(
          subtitle,
          style: AppTextStyle.textSm
              .addAll([AppTextStyle.textSm.leading5]).copyWith(
                  color: context.textThemeColors.brandTextLight),
        ),
      ),
      trailing: Padding(
        padding: AppPadding.pr8,
        child: PlusIconWidget(
          color: AppColors.gray400,
          onTap: onTapAdd,
        ),
      ),
      index: index,
      onTap: onTap,
      rippleColor: primaryColor,
      isLoading: isLoading,
      enableSlidable: true,
      endActionPane: ActionPane(
        extentRatio: 0.6,
        motion: const DrawerMotion(),
        dismissible: DismissiblePane(
          onDismissed: () => onTapDelete?.call(true),
        ),
        children: [
          SlidableAction(
            onPressed: (context) => onTapEdit?.call(),
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            label: context.localization.edit,
          ),
          SlidableAction(
            onPressed: (context) => onTapDelete?.call(false),
            backgroundColor: AppColors.red500,
            foregroundColor: Colors.white,
            label: context.localization.delete,
          ),
        ],
      ),
    );
  }
}
