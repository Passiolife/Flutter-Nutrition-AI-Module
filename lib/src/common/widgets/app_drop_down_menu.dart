import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constant/app_constants.dart';

class AppDropDownMenu<T> extends StatelessWidget {
  const AppDropDownMenu({
    required this.dropdownMenuEntries,
    this.initialSelection,
    this.onSelected,
    super.key,
  });

  final T? initialSelection;
  final List<DropdownMenuEntry<T>> dropdownMenuEntries;
  final ValueChanged<T?>? onSelected;

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
              backgroundColor: MaterialStateProperty.all(AppColors.white),
              surfaceTintColor: MaterialStateProperty.all(AppColors.white),
            ),
          ),
        ),
        child: SizedBox(
          height: 64.r,
          child: DropdownMenu<T>(
            // menuHeight: 500.h,
            expandedInsets: EdgeInsets.zero,
            initialSelection: initialSelection,
            trailingIcon: SvgPicture.asset(
              AppImages.icChevronDown,
              width: 20.r,
              height: 20.r,
              colorFilter: const ColorFilter.mode(
                AppColors.gray900,
                BlendMode.srcIn,
              ),
            ),
            selectedTrailingIcon: SvgPicture.asset(
              AppImages.icChevronUp,
              width: 20.r,
              height: 20.r,
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
