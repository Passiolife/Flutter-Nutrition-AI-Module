import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../common/constant/app_constants.dart';
import '../../../../../../common/extension/context_extension.dart';
import '../../../../../../common/widgets/action_buttons_widget.dart';

class BarcodeWidget extends StatelessWidget {
  const BarcodeWidget({
    this.title,
    this.description,
    this.onTapCancel,
    this.onViewExistingItem,
    this.customFoodButtonText,
    this.onCreateCustomFood,
    super.key,
  });

  final String? title;
  final String? description;

  final VoidCallback? onTapCancel;
  final VoidCallback? onViewExistingItem;

  final String? customFoodButtonText;
  final VoidCallback? onCreateCustomFood;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        padding: EdgeInsets.all(16.r),
        margin: EdgeInsets.symmetric(horizontal: 16.r),
        child: Material(
          color: AppColors.white,
          surfaceTintColor: AppColors.white,
          child: Column(
            children: [
              SvgPicture.asset(
                AppImages.icBarcode,
                width: 40.r,
                height: 40.r,
              ),
              16.verticalSpace,
              Text(
                title ?? '',
                style: AppTextStyle.textXl.addAll([
                  AppTextStyle.textXl.leading7,
                  AppTextStyle.bold
                ]).copyWith(color: AppColors.gray900),
                textAlign: TextAlign.center,
              ),
              Text(
                description ?? '',
                style: AppTextStyle.textSm
                    .addAll([AppTextStyle.textSm.leading5]).copyWith(
                        color: AppColors.gray900),
                textAlign: TextAlign.center,
              ),
              16.verticalSpace,
              Flexible(
                child: ActionButtonsWidget(
                  negativeButtonText: context.localization?.cancel,
                  onNegativeButtonTap: onTapCancel,
                  positiveButtonText: context.localization?.viewExistingItem,
                  onPositiveButtonTap: onViewExistingItem,
                  neutralButtonText: customFoodButtonText,
                  onNeutralButtonTap: onCreateCustomFood,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
