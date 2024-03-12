import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../common/constant/app_colors.dart';
import '../../../common/constant/app_dimens.dart';
import '../../../common/constant/app_images.dart';
import '../../../common/constant/app_shadow.dart';
import '../../../common/constant/app_text_styles.dart';
import '../../../common/external_packages/table_calendar/table_calendar.dart';
import '../../../common/models/day_log/day_log.dart';
import '../../../common/models/day_logs/day_logs.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/date_time_utility.dart';

class WeeklyAdherenceWidget extends StatelessWidget {
  const WeeklyAdherenceWidget({
    required this.selectedDate,
    this.dayLogs,
    this.onPageChanged,
    super.key,
  });

  final DateTime selectedDate;
  final DayLogs? dayLogs;
  final Function(DateTime focusedDay)? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      padding: EdgeInsets.all(AppDimens.r16),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                AppImages.icBadgeCheck,
                width: AppDimens.r20,
                height: AppDimens.r20,
              ),
              SizedBox(width: AppDimens.w8),
              Expanded(
                child: Text(
                  context.localization?.weeklyAdherence ?? '',
                  style: AppTextStyle.textLg.addAll([
                    AppTextStyle.textLg.leading6,
                    AppTextStyle.semiBold
                  ]).copyWith(color: AppColors.gray900),
                ),
              ),
              /*SvgPicture.asset(
                AppImages.icExternalLink,
                width: AppDimens.r24,
                height: AppDimens.r24,
              ),*/
            ],
          ),
          TableCalendar(
            firstDay: DateTime.utc(1, 1, 1),
            lastDay: DateTime(9999, 12, 31),
            focusedDay: selectedDate,
            rowHeight: AppDimens.r40,
            calendarFormat: CalendarFormat.week,
            onPageChanged: onPageChanged,
            enabledDayPredicate: (dateTime) {
              // Compare the current date and time with the provided dateTime.
              // If the current date and time are equal to or greater than dateTime, return true.
              return DateTime.now().compareTo(dateTime) >= 0;
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextFormatter: (DateTime date, dynamic locale) {
                ({DateTime startDate, DateTime endDate}) rangeDates =
                    date.weekStartEndDates();

                // Format the start and end dates
                String formattedStartDate =
                    DateFormat('M/d/yy', locale).format(rangeDates.startDate);
                String formattedEndDate =
                    DateFormat('M/d/yy', locale).format(rangeDates.endDate);

                // Return the formatted date range
                return '$formattedStartDate - $formattedEndDate';
              },
              headerPadding: EdgeInsets.symmetric(vertical: AppDimens.h16),
              leftChevronPadding: EdgeInsets.only(right: AppDimens.w32),
              rightChevronPadding: EdgeInsets.only(left: AppDimens.w32),
              leftChevronMargin: EdgeInsets.zero,
              rightChevronMargin: EdgeInsets.zero,
              titleTextStyle: AppTextStyle.textSm.addAll([
                AppTextStyle.textSm.leading5,
                AppTextStyle.semiBold
              ]).copyWith(color: AppColors.gray900),
              leftChevronIcon: SvgPicture.asset(
                AppImages.icChevronLeft,
                width: AppDimens.r20,
                height: AppDimens.r20,
              ),
              rightChevronIcon: SvgPicture.asset(
                AppImages.icChevronRight,
                width: AppDimens.r20,
                height: AppDimens.r20,
              ),
            ),
            selectedDayPredicate: (day) {
              return isSameDay(selectedDate, day);
            },
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: AppTextStyle.textXs.addAll([
                AppTextStyle.textXs.leading4,
                AppTextStyle.medium
              ]).copyWith(color: AppColors.gray700),
              weekendStyle: AppTextStyle.textXs.addAll([
                AppTextStyle.textXs.leading4,
                AppTextStyle.medium
              ]).copyWith(color: AppColors.gray700),
            ),
            calendarBuilders: CalendarBuilders(
              disabledBuilder: (context, day, focusedDay) {
                if (isSameDay(selectedDate, day)) {
                  return _CustomCircleAvatar(
                    backgroundColor: AppColors.indigo600Main,
                    day: day.day,
                    textColor: AppColors.white,
                  );
                }
                return _CustomCircleAvatar(
                  backgroundColor: AppColors.indigo50,
                  day: day.day,
                  textColor: AppColors.gray400,
                );
              },
              todayBuilder: (context, day, focusedDay) {
                bool containsRecords = dayLogs?.dayLog
                        .cast<DayLog?>()
                        .firstWhere(
                            (element) => element?.date.isSameDate(day) ?? false,
                            orElse: () => null)
                        ?.records
                        .isNotEmpty ??
                    false;

                return _CustomBorderedCircleAvatar(
                  backgroundColor:
                      containsRecords ? AppColors.green100 : AppColors.red100,
                  day: day.day,
                  textColor:
                      containsRecords ? AppColors.green800 : AppColors.red800,
                  borderColor: AppColors.indigo600Main,
                );
              },
              selectedBuilder: (context, day, focusedDay) {
                return _CustomCircleAvatar(
                  backgroundColor: AppColors.indigo600Main,
                  day: day.day,
                  textColor: AppColors.white,
                );
              },
              defaultBuilder: (context, day, focusedDay) {
                bool containsRecords = dayLogs?.dayLog
                        .cast<DayLog?>()
                        .firstWhere(
                            (element) => element?.date.isSameDate(day) ?? false,
                            orElse: () => null)
                        ?.records
                        .isNotEmpty ??
                    false;

                return _CustomCircleAvatar(
                  backgroundColor:
                      containsRecords ? AppColors.green100 : AppColors.red100,
                  day: day.day,
                  textColor:
                      containsRecords ? AppColors.green800 : AppColors.red800,
                );
              },
              outsideBuilder: (context, day, focusedDay) {
                bool containsRecords = dayLogs?.dayLog
                        .cast<DayLog?>()
                        .firstWhere(
                            (element) => element?.date.isSameDate(day) ?? false,
                            orElse: () => null)
                        ?.records
                        .isNotEmpty ??
                    false;

                return _CustomCircleAvatar(
                  backgroundColor:
                      containsRecords ? AppColors.green100 : AppColors.red100,
                  day: day.day,
                  textColor:
                      containsRecords ? AppColors.green800 : AppColors.red800,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomCircleAvatar extends StatelessWidget {
  final Color backgroundColor;
  final int day;
  final Color textColor;

  const _CustomCircleAvatar({
    required this.backgroundColor,
    required this.day,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: backgroundColor,
      foregroundColor: AppColors.red600Error,
      radius: AppDimens.r16,
      child: Center(
        child: Text(
          '$day',
          style: AppTextStyle.textXs.addAll([
            AppTextStyle.textXs.leading4,
            AppTextStyle.semiBold
          ]).copyWith(color: textColor),
        ),
      ),
    );
  }
}

class _CustomBorderedCircleAvatar extends StatelessWidget {
  final Color backgroundColor;
  final int day;
  final Color textColor;
  final Color borderColor;

  const _CustomBorderedCircleAvatar({
    required this.backgroundColor,
    required this.day,
    required this.textColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimens.r32,
      height: AppDimens.r32,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor),
      ),
      child: Center(
        child: Text(
          '$day',
          style: AppTextStyle.textXs.addAll([
            AppTextStyle.textXs.leading4,
            AppTextStyle.semiBold
          ]).copyWith(color: textColor),
        ),
      ),
    );
  }
}
