import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../common/extension/context_extension.dart';
import '../../../common/widgets/camera/capture_button_widget.dart';

class CameraControlWidget extends StatelessWidget {
  const CameraControlWidget({
    this.captureEnabled = true,
    this.onCapture,
    super.key,
  });

  final bool captureEnabled;
  final VoidCallback? onCapture;


  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: context.bottomPaddingValue + 40.h,
      left: 0,
      right: 0,
      child: CaptureButtonWidget(
        isEnabled: captureEnabled,
        onTap: onCapture,
      ),
    );
  }
}
