import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/widgets/food_item_row_widget.dart';

class CustomFoodsRowWidget extends StatelessWidget {
  const CustomFoodsRowWidget({
    required this.index,
    required this.name,
    required this.additionalData,
    required this.iconId,
    this.onTap,
    this.onTapAdd,
    this.onDelete,
    this.onEdit,
    super.key,
  });

  final String name;
  final String additionalData;
  final String iconId;
  final int index;
  final VoidCallback? onEdit;
  final VoidCallback? onTap;
  final VoidCallback? onTapAdd;

  // return bool true if forcible delete is requested.
  // return bool false if normal delete is requested.
  final ValueChanged<bool>? onDelete;

  @override
  Widget build(BuildContext context) {
    return FoodItemRowWidget(
      data: FoodItemRowData(
        rippleColor: AppColors.white,
        padding: EdgeInsets.all(8.r),
        index: index,
        title: name,
        iconId: iconId,
        subtitle: additionalData,
        onTap: onTap,
        onTapAdd: onTapAdd,
        enableSlidable: true,
        onTapEdit: onEdit,
        onTapDelete: onDelete,
      ),
    );
  }
}
