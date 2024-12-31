import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vector_graphics/vector_graphics.dart';

import '../../constant/app_constants.dart';

class TrashIconWidget extends StatelessWidget {
  const TrashIconWidget({
    this.color = AppColors.white,
    this.width,
    this.height,
    super.key,
  });

  final Color? color;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return VectorGraphic(
      loader: AssetBytesLoader(AppImages.icTrashNew),
      width: width ?? 20.r,
      height: height ?? 20.r,
      colorFilter: const ColorFilter.mode(
        AppColors.white,
        BlendMode.srcIn,
      ),
    );
  }
}
