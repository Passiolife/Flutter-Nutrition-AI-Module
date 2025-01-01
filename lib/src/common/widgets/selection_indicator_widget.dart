import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/constant/app_colors.dart';

class SelectionIndicator extends StatefulWidget {
  final bool isSelected;

  const SelectionIndicator({super.key, required this.isSelected});

  @override
  State<SelectionIndicator> createState() => _SelectionIndicatorState();
}

class _SelectionIndicatorState extends State<SelectionIndicator> {
  late bool _isSelected;

  @override
  void initState() {
    _isSelected = widget.isSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: AnimatedContainer(
        key: ValueKey<bool>(widget.isSelected),
        duration: const Duration(milliseconds: 250),
        width: 24.r,
        height: 24.r,
        decoration: BoxDecoration(
          color: widget.isSelected ? AppColors.indigo600Main : AppColors.white,
          shape: BoxShape.circle,
          border: widget.isSelected ? null : Border.all(color: AppColors.gray300),
        ),
      ),
    );
  }
}
