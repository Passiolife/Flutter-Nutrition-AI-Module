import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vector_graphics/vector_graphics.dart';

import '../../constant/app_constants.dart';

class BarcodeScanWidget extends StatelessWidget {
  const BarcodeScanWidget({
    this.color = AppColors.brandIconLight,
    this.width,
    this.height,
    this.onTap,
    super.key,
  });

  final Color color;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return VectorGraphic(
      loader: AssetBytesLoader(AppImages.icBarcodeScan),
      width: width ?? 24.r,
      height: height ?? 24.r,
      colorFilter: ColorFilter.mode(
        color,
        BlendMode.srcIn,
      ),
    );
  }
}
