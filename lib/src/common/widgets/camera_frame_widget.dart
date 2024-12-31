import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vector_graphics/vector_graphics.dart';

import '../constant/app_images.dart';

class CameraFrameWidget extends StatelessWidget {
  const CameraFrameWidget({this.height, super.key});
  final double? height;

  @override
  Widget build(BuildContext context) {
    return VectorGraphic(
      loader: AssetBytesLoader(AppImages.icScanFrameNew),
      width: double.infinity,
      fit: BoxFit.fill,
      height: height ?? 240.h,
    );
  }
}
