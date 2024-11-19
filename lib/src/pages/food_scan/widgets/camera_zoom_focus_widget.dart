import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/widgets/app_slider.dart';

class CameraZoomFocusWidget extends StatelessWidget {
  const CameraZoomFocusWidget({
    this.currentZoomLevel = 1,
    this.minZoomLevel = 1,
    this.maxZoomLevel = 10,
    this.onChanged,
    this.isFocusOn = false,
    this.onChangeFocus,
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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppSlider(
            value: currentZoomLevel,
            min: minZoomLevel,
            max: maxZoomLevel,
            onChanged: onChanged,
          ),
        ),
        24.horizontalSpace,
        IconButton(
          onPressed: onChangeFocus,
          icon: SvgPicture.asset(
            isFocusOn ? AppImages.icSolidFocusOn : AppImages.icSolidFocusOff,
            width: 32.r,
            height: 32.r,
          ),
        ),
      ],
    );
  }
}
