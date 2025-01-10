import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/constant/app_padding.dart';
import '../../../common/extension/context_extension.dart';
import '../../../common/widgets/app_button.dart';

class BarcodeNotRecognizedWidget extends StatelessWidget {
  const BarcodeNotRecognizedWidget({
    this.onTapTakePhoto,
    this.onTapCancel,
    super.key,
  });

  final VoidCallback? onTapTakePhoto;
  final VoidCallback? onTapCancel;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppDimens.r16),
        ),
        padding: AppPadding.pa16,
        margin: AppPadding.ph16 + AppPadding.pb64,
        child: Material(
          color: AppColors.white,
          surfaceTintColor: AppColors.white,
          child: Column(
            children: [
              SvgPicture.asset(
                AppImages.icBarcodeNotRecognized,
                width: AppDimens.r40,
                height: AppDimens.r40,
              ),
              SizedBox(height: AppDimens.h16),
              Text(
                context.localization.barcodeNotRecognized ?? '',
                style: AppTextStyle.textXl.addAll([AppTextStyle.bold]),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppDimens.h4),
              Text(
                context.localization.barcodeNotRecognizedDescription ?? '',
                style: AppTextStyle.textSm,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: AppDimens.h16),
              Row(
                spacing: 16.w,
                children: [
                  Expanded(
                    child: AppButton(
                      buttonText: context.localization.cancel,
                      appButtonModel: AppButtonStyles.primaryBordered.copyWith(
                        padding: EdgeInsets.symmetric(vertical: AppDimens.h13),
                      ),
                      onTap: onTapCancel,
                    ),
                  ),
                  Expanded(
                    child: AppButton(
                      buttonText: context.localization.takePhoto,
                      appButtonModel: AppButtonStyles.primary.copyWith(
                        padding: EdgeInsets.symmetric(vertical: AppDimens.h13),
                      ),
                      onTap: onTapTakePhoto,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
