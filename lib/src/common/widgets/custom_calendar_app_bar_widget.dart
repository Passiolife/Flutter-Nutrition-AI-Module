import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constant/app_constants.dart';
import '../util/context_extension.dart';
import '../util/date_picker.dart';
import '../util/date_time_utility.dart';

class CustomCalendarAppBarWidget extends StatelessWidget {
  const CustomCalendarAppBarWidget({
    required this.selectedDate,
    this.onDateTimeChanged,
    super.key,
  });

  final DateTime selectedDate;
  final OnDateTimeChanged? onDateTimeChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ChevronWidget(
          assetPath: AppImages.icChevronLeft,
          onTap: () {
            onDateTimeChanged
                ?.call(selectedDate.subtract(const Duration(days: 1)));
          },
        ),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            DatePicker.showAdaptive(
              context: context,
              selectedDate: selectedDate,
              onDateTimeChanged: onDateTimeChanged,
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppDimens.w24),
            child: Row(
              children: [
                SvgPicture.asset(
                  AppImages.icCalendar,
                  width: AppDimens.r24,
                  height: AppDimens.r24,
                ),
                SizedBox(width: AppDimens.w8),
                Center(
                  child: Text(
                    (selectedDate.isToday())
                        ? context.localization?.today ?? ''
                        : selectedDate.formatToString(format8),
                    style: AppTextStyle.textSm.addAll([
                      AppTextStyle.textSm.leading5,
                      AppTextStyle.semiBold
                    ]).copyWith(color: AppColors.gray900),
                  ),
                ),
              ],
            ),
          ),
        ),
        _ChevronWidget(
          assetPath: AppImages.icChevronRight,
          onTap: () {
            onDateTimeChanged?.call(selectedDate.add(const Duration(days: 1)));
          },
        ),
      ],
    );
  }
}

class _ChevronWidget extends StatelessWidget {
  const _ChevronWidget({required this.assetPath, this.onTap});

  final String assetPath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimens.w8,
          vertical: AppDimens.h8,
        ),
        child: SvgPicture.asset(
          assetPath,
          width: AppDimens.r24,
          height: AppDimens.r24,
        ),
      ),
    );
  }
}
