import 'package:flutter/material.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/dimens.dart';
import '../../../common/constant/styles.dart';
import '../../../common/util/context_extension.dart';

class AddItemButtonWidget extends StatelessWidget {
  const AddItemButtonWidget({this.onTap, super.key});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.buttonColor,
        ),
        padding: EdgeInsets.symmetric(horizontal: Dimens.w12, vertical: Dimens.h4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.add,
              color: AppColors.whiteColor,
              size: 16,
            ),
            Text(
              context.localization?.addItem ?? '',
              style: AppStyles.style17.copyWith(color: AppColors.whiteColor),
            )
          ],
        ),
      ),
    );
  }
}
