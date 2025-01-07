import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/extension/context_extension.dart';
import '../../../common/widgets/button/primary_button.dart';
import '../../../common/widgets/button/secondary_button.dart';
import '../../../common/widgets/camera/capture_button_widget.dart';

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
          8.horizontalSpace,
          Expanded(
            child: SecondaryButton(
              text: context.localization.cancel,
              onTap: negativeEnabled ? onNegativeTap : null,
              enabled: negativeEnabled,
            ),     ),
          16.horizontalSpace,
          CaptureButtonWidget(
            onTap: () {},
          ),
          16.horizontalSpace,
          Expanded(
            child: PrimaryButton(
              text: context.localization.next,
              onTap: onPositiveTap,
            ),
          ),
          8.horizontalSpace,
        ],
      ),
    );
  }
}
