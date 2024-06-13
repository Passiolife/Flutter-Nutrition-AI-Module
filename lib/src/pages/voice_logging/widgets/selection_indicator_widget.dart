import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_colors.dart';

class SelectionIndicator extends StatelessWidget {
  final bool isSelected;

  const SelectionIndicator({super.key, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      key: ValueKey<bool>(isSelected),
      duration: const Duration(milliseconds: 250),
      width: 24.r,
      height: 24.r,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.indigo600Main : AppColors.white,
        shape: BoxShape.circle,
        border: isSelected ? null : Border.all(color: AppColors.gray300),
      ),
    );
  }
}
