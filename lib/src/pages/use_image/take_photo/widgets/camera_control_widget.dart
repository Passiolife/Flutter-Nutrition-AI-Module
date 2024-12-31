import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../common/constant/app_constants.dart';
import '../../../../common/extension/context_extension.dart';
import '../../../../common/widgets/app_button.dart';
import '../../../../common/widgets/app_loading_button_widget.dart';

class CameraControlWidget extends StatelessWidget {
  const CameraControlWidget({
    this.negativeEnabled = true,
    this.onNegativeTap,
    this.captureEnabled = true,
    this.onCapture,
    this.positiveEnabled = true,
    this.onPositiveTap,
    this.loadingPositiveButton = false,
    super.key,
  });

  final bool negativeEnabled;
  final VoidCallback? onNegativeTap;
  final bool captureEnabled;
  final VoidCallback? onCapture;

  final bool positiveEnabled;
  final bool loadingPositiveButton;
  final VoidCallback? onPositiveTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: context.bottomPadding + 40.h,
      left: 0,
      right: 0,
      child: Row(
        children: [
          16.horizontalSpace,
          Expanded(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: negativeEnabled ? 1 : 0.4,
              child: AppButton(
                buttonText: context.localization?.cancel,
                appButtonModel: AppButtonStyles.primaryBordered,
                onTap: negativeEnabled ? onNegativeTap : null,
              ),
            ),
          ),
          16.horizontalSpace,
          AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: captureEnabled ? 1 : 0.4,
            child: IconButton(
              onPressed: captureEnabled ? onCapture : null,
              icon: SvgPicture.asset(
                AppImages.icCapture,
                width: 78.r,
                height: 78.r,
              ),
            ),
          ),
          16.horizontalSpace,
          Expanded(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 250),
              opacity: positiveEnabled ? 1 : 0.4,
              child: AppButton(
                isLoading: loadingPositiveButton,
                buttonText: context.localization?.next,
                appButtonModel: positiveEnabled
                    ? AppButtonStyles.primary
                    : AppButtonStyles.primary.copyWith(
                        decoration: AppButtonStyles.primary.decoration
                            ?.copyWith(
                                color: AppButtonStyles.primary.decoration?.color
                                    ?.withOpacity(0.4)),
                      ),
                onTap: onPositiveTap,
              ),
            ),
          ),
          16.horizontalSpace,
        ],
      ),
    );
  }
}
