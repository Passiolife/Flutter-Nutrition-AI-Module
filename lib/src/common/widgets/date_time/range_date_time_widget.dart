import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constant/app_constants.dart';
import '../../util/date_time_utility.dart';

enum DatesPeriod {
  week,
  month,
}

typedef OnRangeChange = Function(DateTime startDate, DateTime endDate);

class RangeDateTimeWidget extends StatefulWidget {
  const RangeDateTimeWidget({
    this.period = DatesPeriod.week,
    this.onRangeChange,
    super.key,
  });

  final DatesPeriod period;
  final OnRangeChange? onRangeChange;

  @override
  State<RangeDateTimeWidget> createState() => _RangeDateTimeWidgetState();
}

class _RangeDateTimeWidgetState extends State<RangeDateTimeWidget> {
  static const _weekDay = DateTime.monday;
  late DateTime _currentDate = DateTime.now().toUtc();

  late ({DateTime startDate, DateTime endDate}) _rangeDates;

  bool get isMonthPeriod => widget.period == DatesPeriod.month;

  String get _weekRange => DateTime.now().toUtc()
          .isSame(from: _rangeDates.startDate, to: _rangeDates.endDate)
      ? 'This Week'
      : '${_rangeDates.startDate.formatToString(format14)} - ${_rangeDates.endDate.formatToString(format14)}';

  String get _monthRange => DateTime.now().toUtc()
      .isSame(from: _rangeDates.startDate, to: _rangeDates.endDate)
      ? 'This Month'
      : _rangeDates.startDate.formatToString(format17);

  String get _dateRange => isMonthPeriod ? _monthRange : _weekRange;

  @override
  void initState() {
    super.initState();
    _updateRangeDates();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          iconSize: AppDimens.r12,
          visualDensity: VisualDensity.compact,
          onPressed: () {
            _previousDate();
          },
          icon: SvgPicture.asset(
            AppImages.icChevronLeft,
            width: AppDimens.r24,
            height: AppDimens.r24,
            colorFilter:
                const ColorFilter.mode(AppColors.gray400, BlendMode.srcIn),
          ),
          disabledColor: AppColors.gray200,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.w16),
          child: Text(
            _dateRange,
            style: AppTextStyle.textSm.addAll(
              [AppTextStyle.textSm.leading5, AppTextStyle.semiBold],
            ),
          ),
        ),
        IconButton(
          iconSize: AppDimens.r12,
          visualDensity: VisualDensity.compact,
          onPressed: () {
            _nextDate();
          },
          icon: SvgPicture.asset(
            AppImages.icChevronRight,
            width: AppDimens.r24,
            height: AppDimens.r24,
            colorFilter:
                const ColorFilter.mode(AppColors.gray400, BlendMode.srcIn),
          ),
          disabledColor: AppColors.gray200,
        ),
      ],
    );
  }

  void _previousDate() {

    if (isMonthPeriod) {
      // Handle month change
      _currentDate = DateTime(
        _currentDate.year,
        _currentDate.month - 1,
      );
    } else {
      // Handle week change
      _currentDate = _currentDate.subtract(const Duration(days: 7));
    }
    _updateRangeDates();
    setState(() {
    });
  }

  void _nextDate() {
    if (isMonthPeriod) {
      // Handle month change
      _currentDate = DateTime(
        _currentDate.year,
        _currentDate.month + 1,
      );
    } else {
      // Handle week change
      _currentDate = _currentDate.add(const Duration(days: 7));
    }

    _updateRangeDates();
    setState(() {
    });
  }

  void _updateRangeDates() {
    if (widget.period == DatesPeriod.month) {
      _rangeDates = _currentDate.monthRangeDates(weekDay: _weekDay);
    } else {
      _rangeDates = _currentDate.weekRangeDates(weekDay: _weekDay);
    }
    widget.onRangeChange?.call(_rangeDates.startDate, _rangeDates.endDate);
  }
}
