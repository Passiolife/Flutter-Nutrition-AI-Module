import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vector_graphics/vector_graphics.dart';

import '../../constant/app_constants.dart';

class HelpWidget extends StatelessWidget {
  const HelpWidget({
    this.color = AppColors.white,
    this.width,
    this.height,
    this.onTap,
    super.key,
  });

  final Color? color;
  final double? width;
  final double? height;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: VectorGraphic(
        loader: AssetBytesLoader(AppImages.icQuestionMark),
        width: width ?? 24.r,
        height: height ?? 24.r,
        colorFilter: const ColorFilter.mode(
          AppColors.brandIconLight,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
