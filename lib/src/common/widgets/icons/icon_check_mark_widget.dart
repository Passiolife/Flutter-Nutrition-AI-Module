import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vector_graphics/vector_graphics.dart';

import '../../constant/app_constants.dart';

class IconCheckMarkWidget extends StatelessWidget {
  const IconCheckMarkWidget({
    this.color = AppColors.green500Success,
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
    return IconButton(
      onPressed: onTap,
      icon: VectorGraphic(
        loader: AssetBytesLoader(AppImages.icCheckMarkNew),
        width: width ?? 24.r,
        height: height ?? 24.r,
        colorFilter: ColorFilter.mode(
          color,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
