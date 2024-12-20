import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/widgets/app_slider.dart';

class CameraControlWidget extends StatelessWidget {
  const CameraControlWidget({
    this.currentZoomLevel = 1,
    this.minZoomLevel = 1,
    this.maxZoomLevel = 10,
    this.onChanged,
    this.isFocusOn = false,
    this.onChangeFocus,
    this.isFlashOn = false,
    this.onChangeFlash,
    super.key,
  });

  // Zoom related
  final double currentZoomLevel;
  final double minZoomLevel;
  final double maxZoomLevel;
  final ValueChanged<double>? onChanged;

  // Focus related
  final bool isFocusOn;
  final VoidCallback? onChangeFocus;
  final bool isFlashOn;
  final VoidCallback? onChangeFlash;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16.w,
      children: [
        Expanded(
          child: AppSlider(
            value: currentZoomLevel,
            min: minZoomLevel,
            max: maxZoomLevel,
            onChanged: onChanged,
          ),
        ),
        IconButton(
          onPressed: onChangeFocus,
          icon: SvgPicture.asset(
            isFocusOn ? AppImages.icSolidFocusOn : AppImages.icSolidFocusOff,
            width: 32.r,
            height: 32.r,
          ),
        ),
        IconButton(
          onPressed: onChangeFlash,
          icon: VectorGraphic(
            loader: AssetBytesLoader(
                isFlashOn ? AppImages.icFlashOn : AppImages.icFlashOff),
            colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
            width: 32.r,
            height: 32.r,
          ),
        ),
      ],
    );
  }
}
