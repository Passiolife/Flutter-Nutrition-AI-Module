import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constant/app_colors.dart';
import 'base_check_box.dart';

class PrimaryCheckBox extends BaseCheckBox {
  PrimaryCheckBox({
    double? size,
    bool isSelected = false,
    Duration duration = const Duration(milliseconds: 250),
    ValueChanged<bool>? onChanged,
    super.key,
  }) : super(
          size: size ?? 24.r,
          selectedColor: AppColors.indigo600Main,
          unselectedColor: AppColors.white,
          isSelected: isSelected,
          duration: duration,
          onChanged: onChanged,
        );
}
