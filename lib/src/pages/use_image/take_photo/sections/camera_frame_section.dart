import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/camera_frame_widget.dart';

class CameraFrameSection extends StatelessWidget {
  const CameraFrameSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 200.h,
      left: 24.w,
      right: 24.w,
      child: CameraFrameWidget(height: 380.h),
    );
  }
}
