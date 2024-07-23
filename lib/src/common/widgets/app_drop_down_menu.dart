import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constant/app_constants.dart';

class AppDropDownMenu<T> extends StatelessWidget {
  const AppDropDownMenu({
    required this.dropdownMenuEntries,
    this.initialSelection,
    this.onSelected,
    this.hintText,
    this.shape,
    this.menuHeight,
    super.key,
  });

  final T? initialSelection;
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;
  final ValueChanged<T?>? onSelected;
  final String? hintText;
  final WidgetStateProperty<OutlinedBorder?>? shape;
  final double? menuHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 42.h),
      child: Theme(
        data: ThemeData(
          dropdownMenuTheme: DropdownMenuThemeData(
            textStyle: AppTextStyle.textBase.copyWith(color: AppColors.gray900),
            inputDecorationTheme: InputDecorationTheme(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.r),
                borderSide: const BorderSide(color: AppColors.gray300),
              ),
            ),
            menuStyle: MenuStyle(
              backgroundColor: WidgetStateProperty.all(AppColors.white),
              surfaceTintColor: WidgetStateProperty.all(AppColors.white),
              shape: shape,
            ),
          ),
        ),
        child: SizedBox(
          height: 64.r,
          child: DropdownMenu<T>(
            menuHeight: menuHeight,
            expandedInsets: EdgeInsets.zero,
            initialSelection: initialSelection,
            hintText: hintText,
            trailingIcon: SvgPicture.asset(
              AppImages.icChevronDown,
              width: 24.r,
              height: 24.r,
              colorFilter: const ColorFilter.mode(
                AppColors.gray900,
                BlendMode.srcIn,
              ),
            ),
            selectedTrailingIcon: SvgPicture.asset(
              AppImages.icChevronUp,
              width: 24.r,
              height: 24.r,
              colorFilter: const ColorFilter.mode(
                AppColors.gray900,
                BlendMode.srcIn,
              ),
            ),
            dropdownMenuEntries: dropdownMenuEntries,
            onSelected: onSelected,
          ),
        ),
      ),
    );
  }
}
