import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/extension/context_extension.dart';
import '../../../common/external_packages/table_calendar/table_calendar.dart';
import '../../../common/models/day_log/day_log.dart';
import '../../../common/models/day_logs/day_logs.dart';
import '../../../common/util/date_time_utility.dart';
import '../../../common/widgets/icons/icon_chevron_down_widget.dart';

class WeeklyAdherenceWidget extends StatefulWidget {
  const WeeklyAdherenceWidget({
    required this.selectedDate,
    required this.focusedDate,
    this.dayLogs,
    this.startDateTime,
    this.endDateTime,
    this.onSelectorChanged,
    super.key,
  });

  final DateTime selectedDate;
  final DateTime focusedDate;
  final DayLogs? dayLogs;
  final DateTime? startDateTime;
  final DateTime? endDateTime;
  final Function(DateTime focusedDate, DateTime startDate, DateTime endDate)? onSelectorChanged;

  @override
  State<WeeklyAdherenceWidget> createState() => _WeeklyAdherenceWidgetState();
}

class _WeeklyAdherenceWidgetState extends State<WeeklyAdherenceWidget> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;
  bool get _isMonthRange => _calendarFormat == CalendarFormat.month;

  @override
  void initState() {
    _onPageChanged(widget.selectedDate);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant WeeklyAdherenceWidget oldWidget) {
    if (oldWidget.selectedDate != widget.selectedDate) {
      _onPageChanged(widget.selectedDate);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppShadows.base,
      padding: AppPadding.pl16 + AppPadding.pb16,
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
                  context.localization.weeklyAdherence,
                  style: AppTextStyle.textLg.addAll([
                    AppTextStyle.textLg.leading6,
                    AppTextStyle.semiBold
                  ]).copyWith(color: AppColors.gray900),
                ),
              ),
              IconChevronDownWidget(
                color: AppColors.gray400,
                width: AppDimens.r24,
                height: AppDimens.r24,
                onTap: _onChangeFormat,
              ),
              // GestureDetector(
              //   behavior: HitTestBehavior.opaque,
              //   onTap: _onChangeFormat,
              //   child: SvgPicture.asset(
              //     AppImages.icChevronDown,
              //     width: AppDimens.r24,
              //     height: AppDimens.r24,
              //     colorFilter: const ColorFilter.mode(
              //         AppColors.gray400, BlendMode.srcIn),
              //   ),
              // ),
            ],
          ),
          Padding(
            padding: AppPadding.pr16,
            child: TableCalendar(
              firstDay: DateTime.utc(1, 1, 1),
              lastDay: DateTime(9999, 12, 31),
              focusedDay: widget.focusedDate,
              rowHeight: AppDimens.r40,
              calendarFormat: _calendarFormat,
              onPageChanged: _onPageChanged,
              calendarStyle: const CalendarStyle(
                // Use `CalendarStyle` to customize the UI
                outsideDaysVisible: false,
              ),
              enabledDayPredicate: (dateTime) {
                // Compare the current date and time with the provided dateTime.
                // If the current date and time are equal to or greater than dateTime, return true.
                return DateTime.now().compareTo(dateTime) >= 0;
              },
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextFormatter: (DateTime date, dynamic locale) {
                  return _startDate.rangeString(
                    endDateTime: _endDate,
                    isMonthRange: _isMonthRange,
                  );
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
                return isSameDay(widget.selectedDate, day);
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
                  bool isSameDate = isSameDay(widget.selectedDate, day);
                  bool containsRecords = widget.dayLogs?.dayLog.any((element) =>
                          isSameDay(element.date, day) &&
                          element.records.isNotEmpty) ??
                      false;

                  return _CustomCircleAvatar(
                    backgroundColor: isSameDate
                        ? AppColors.indigo600Main
                        : containsRecords
                            ? AppColors.green100
                            : AppColors.indigo50,
                    day: day.day,
                    textColor: isSameDate
                        ? AppColors.white
                        : containsRecords
                            ? AppColors.green800
                            : AppColors.gray400,
                  );
                },
                todayBuilder: (context, day, focusedDay) {
                  bool containsRecords = widget.dayLogs?.dayLog.any((element) =>
                          isSameDay(element.date, day) &&
                          element.records.isNotEmpty) ??
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
                  bool containsRecords = widget.dayLogs?.dayLog
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
                  bool containsRecords = widget.dayLogs?.dayLog
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
          ),
        ],
      ),
    );
  }

  void _onChangeFormat() {
    setState(() {
      _calendarFormat = _calendarFormat == CalendarFormat.week
          ? CalendarFormat.month
          : CalendarFormat.week;
    });
    _onPageChanged(widget.selectedDate);
  }

  void _onPageChanged(DateTime date) {
    ({DateTime startDate, DateTime endDate}) dateRange;
    if (_isMonthRange) {
      dateRange = date.monthStartEndDates();
    } else {
      dateRange = date.weekStartEndDates();
    }
    _startDate = dateRange.startDate;
    _endDate = dateRange.endDate;
    widget.onSelectorChanged?.call(date, _startDate, _endDate);
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
