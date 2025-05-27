import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/extension/context_extension.dart';
import '../../../common/widgets/vector/vector_widget.dart';
import 'action_buttons_widget.dart';

class BarcodeInSystemWidget extends StatelessWidget {
  const BarcodeInSystemWidget({
    this.onNegativeButtonTap,
    this.onPositiveButtonTap,
    this.onNeutralButtonTap,
    super.key,
  });

  final VoidCallback? onNegativeButtonTap;

  final VoidCallback? onPositiveButtonTap;

  final VoidCallback? onNeutralButtonTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      padding: EdgeInsets.all(16.r),
      margin: EdgeInsets.symmetric(horizontal: 16.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          VectorWidget(
            imagePath: AppImages.icBarcodeNewNew,
            width: 40.r,
            height: 40.r,
          ),
          16.verticalSpace,
          Text(
            context.localization.barcodeInSystem,
            style: AppTextStyle.textXl.addAll([
              AppTextStyle.textXl.leading7,
              AppTextStyle.bold
            ]).copyWith(color: AppColors.gray900),
            textAlign: TextAlign.center,
          ),
          Text(
            context.localization.barcodeInSystemDescription,
            style: AppTextStyle.textSm
                .addAll([AppTextStyle.textSm.leading5]).copyWith(
                    color: AppColors.gray900),
            textAlign: TextAlign.center,
          ),
          16.verticalSpace,
          ActionButtonsWidget(
            positiveButtonText: context.localization.importExistingData,
            neutralButtonText: context.localization.useBarcodeOnly,
            onNegativeButtonTap: onNegativeButtonTap,
            onPositiveButtonTap: onPositiveButtonTap,
            onNeutralButtonTap: onNeutralButtonTap,
          ),
        ],
      ),
    );
  }
}
