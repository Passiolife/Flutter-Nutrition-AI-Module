import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vector_graphics/vector_graphics.dart';

import '../../../common/constant/app_constants.dart';

class CameraFrameSection extends StatelessWidget {
  const CameraFrameSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 150.h,
      left: 24.w,
      right: 24.w,
      child: VectorGraphic(
        loader: AssetBytesLoader(AppImages.icScanFrame),
        width: double.infinity,
        fit: BoxFit.fill,
        height: 240.h,
      ),
    );
  }
}
