import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';

typedef OnModeChanged = Function(String mode);

class ScannerModeWidget extends StatelessWidget {
  ScannerModeWidget({this.onModeChanged, super.key});

  final OnModeChanged? onModeChanged;
  final ValueNotifier<String> _selectedIcon = ValueNotifier(AppImages.icFoods);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16.h,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _ItemWidget(
            image: AppImages.icFoods,
            isSelected: true,
            onModeChanged: _handleOnChange,
          ),
          24.horizontalSpace,
          _ItemWidget(
            image: AppImages.icBarcode,
            isSelected: false,
            onModeChanged: _handleOnChange,
          ),
          24.horizontalSpace,
          _ItemWidget(
            image: AppImages.icNutritionFacts,
            isSelected: false,
            onModeChanged: _handleOnChange,
          ),
        ],
      ),
    );
  }

  void _handleOnChange(String image) {
    _selectedIcon.value = image;
    _selectedIcon.addListener(() {
      onModeChanged?.call(image);
    });
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({
    required this.image,
    this.isSelected = false,
    this.selectedColor = AppColors.indigo600Main,
    this.onModeChanged,
  });

  final String image;
  final bool isSelected;
  final Color selectedColor;
  final OnModeChanged? onModeChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40.r,
      height: 40.r,
      child: ElevatedButton(
        onPressed: () => onModeChanged?.call(image),
        child: SvgPicture.asset(
          image,
          colorFilter: ColorFilter.mode(
            AppColors.white,
            BlendMode.srcIn,
          ),
        ),
        style: ElevatedButton.styleFrom(
          alignment: Alignment.center,
          shape: const CircleBorder(),
          padding: EdgeInsets.all(8.r),
          backgroundColor:
              isSelected ? selectedColor : AppColors.white.withOpacity(0.4),
        ),
      ),
    );
    return CircleAvatar(
      backgroundColor:
          isSelected ? selectedColor : AppColors.white.withOpacity(0.4),
      radius: 20.r,
      child: SvgPicture.asset(
        AppImages.icFoods,
        width: 24.r,
        height: 24.r,
        colorFilter: ColorFilter.mode(
          AppColors.white,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
