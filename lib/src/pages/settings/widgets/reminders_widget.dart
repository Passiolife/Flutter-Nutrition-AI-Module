import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/widgets/app_switch.dart';

class RemindersWidget extends StatelessWidget {
  const RemindersWidget({
    this.breakfastEnabled = false,
    this.lunchEnabled = false,
    this.dinnerEnabled = false,
    this.onChangedBreakfast,
    this.onChangedLunch,
    this.onChangedDinner,
    super.key,
  });

  // Breakfast
  final bool breakfastEnabled;
  final ValueChanged<bool>? onChangedBreakfast;

  // Lunch
  final bool lunchEnabled;
  final ValueChanged<bool>? onChangedLunch;

  // Dinner
  final bool dinnerEnabled;
  final ValueChanged<bool>? onChangedDinner;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.localization?.reminders ?? '',
            style: AppTextStyle.textBase.addAll(
                [AppTextStyle.textBase.leading6, AppTextStyle.semiBold]),
          ),
          16.verticalSpace,
          _RowWidget(
            title: context.localization?.reminderBreakfast ?? '',
            value: breakfastEnabled,
            onChanged: onChangedBreakfast,
          ),
          16.verticalSpace,
          _RowWidget(
            title: context.localization?.reminderLunch ?? '',
            value: lunchEnabled,
            onChanged: onChangedLunch,
          ),
          16.verticalSpace,
          _RowWidget(
            title: context.localization?.reminderDinner ?? '',
            value: dinnerEnabled,
            onChanged: onChangedDinner,
          ),
        ],
      ),
    );
  }
}

class _RowWidget extends StatelessWidget {
  final String? title;
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _RowWidget({
    this.title,
    this.value = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title ?? '',
            style: AppTextStyle.textSm.addAll([
              AppTextStyle.textSm.leading5,
              AppTextStyle.medium
            ]).copyWith(color: AppColors.gray500),
          ),
        ),
        AppSwitch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
