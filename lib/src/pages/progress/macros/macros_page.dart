import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/models/day_log/day_log.dart';
import '../../../common/models/day_logs/day_logs.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/date_time_utility.dart';
import '../../../common/widgets/app_button.dart';
import 'bloc/macros_bloc.dart';
import 'widgets/widgets.dart';

class MacrosPage extends StatefulWidget {
  const MacrosPage({super.key});

  @override
  State<MacrosPage> createState() => _MacrosPageState();
}

class _MacrosPageState extends State<MacrosPage>
    implements TabChangeListener, RangeDateListener {
  final _bloc = MacrosBloc();

  List<String> get _tabs => [
        context.localization?.week ?? '',
        context.localization?.month ?? '',
      ];

  String? _selectedTab;

  RangeDates? _rangeDates;
  DayLogs? _dayLogs;

  bool get _isMonthTab => _selectedTab != null && _selectedTab != _tabs.first;

  DateTime _selectedDateTime = DateTime.now();

  List<ChartData> get _chartData =>
      _dayLogs?.dayLog
          .map((e) => ChartData(
                (_selectedTab == _tabs.firstOrNull)
                    ? e.date.formatToString(format10).substring(0, 2)
                    : e.date.formatToString(format16),
                e.consumedCalories,
              ))
          .toList() ??
      [];

  double get chartMaximumValue =>
      _dayLogs?.dayLog
          .fold<DayLog?>(
              null,
              (previousValue, element) =>
                  (previousValue?.consumedCalories ?? 0) >
                          element.consumedCalories
                      ? previousValue
                      : element)
          ?.consumedCalories ??
      0;

  double get maximumValue => max(chartMaximumValue, 5);

  // Macros Chart
  List<StackedChartData> get _macrosChartData =>
      _dayLogs?.dayLog
          .map((e) => StackedChartData(
                x: (_selectedTab == _tabs.firstOrNull)
                    ? e.date.formatToString(format10).substring(0, 2)
                    : e.date.formatToString(format16),
                yCarbs: e.consumedCarbs,
                yProtein: e.consumedProteins,
                yFat: e.consumedFat,
              ))
          .toList() ??
      [];

  double get _macrosChartMaximumValue {
    return _dayLogs?.dayLog.fold<List<double>?>(null, (maxValues, log) {
          final currentValues = [
            log.consumedCarbs,
            log.consumedProteins,
            log.consumedFat,
          ];

          if (maxValues == null ||
              currentValues.fold(0.0, (a, b) => a + b) >
                  maxValues.fold(0.0, (a, b) => a + b)) {
            return currentValues;
          } else {
            return maxValues;
          }
        })?.fold(0.0, (a, b) => (a ?? 0) + b) ??
        0.0;
  }

  double get macrosMaximumValue => max(_macrosChartMaximumValue, 5);

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _selectedTab = _tabs.first;
      _fetchRecords();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MacrosBloc, MacrosState>(
      bloc: _bloc,
      listener: (context, state) {
        _handleStateChanges(context: context, state: state);
      },
      buildWhen: (_, state) {
        return state is! MacrosListenerState;
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              24.verticalSpace,
              SubTabBar(
                tabs: _tabs,
                selectedTab: _selectedTab,
                onTabChange: this,
              ),
              24.verticalSpace,
              RangeDateNavigatorWidget(
                startDateTime: _rangeDates?.startDate ?? DateTime.now(),
                endDateTime: _rangeDates?.endDate ?? DateTime.now(),
                listener: this,
                isMonthRange: _isMonthTab,
              ),
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    ListView(
                      shrinkWrap: true,
                      padding:
                          EdgeInsets.only(bottom: context.bottomPadding + 32.h + 48.h),
                      children: [
                        24.verticalSpace,
                        Container(
                          decoration: AppShadows.base.copyWith(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          height: 200.h,
                          child: VerticalBarChartWidget(
                            key: UniqueKey(),
                            title: context.localization?.calories,
                            barColor: AppColors.yellow500,
                            barWidth: 0.4,
                            chartData: _chartData,
                            maximumValue: maximumValue,
                            desiredIntervals: 2,
                          ),
                        ),
                        16.verticalSpace,
                        Container(
                          decoration: AppShadows.base.copyWith(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          height: 200.h,
                          child: VerticalStackedColumnChartWidget(
                            key: UniqueKey(),
                            title: context.localization?.macros,
                            barWidth: 0.4,
                            chartData: _macrosChartData,
                            maximumValue: macrosMaximumValue,
                            desiredIntervals: 2,
                          ),
                        ),
                        16.verticalSpace,
                        const ChartsLegendWidget(),
                      ],
                    ),
                    Positioned(
                      bottom: context.bottomPadding,
                      left: 0,
                      right: 0,
                      child: Container(
                        color:  AppColors.gray50,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          child: AppButton(
                            buttonText: context.localization?.generateReport,
                            appButtonModel: AppButtonStyles.primary,
                            onTap: () {},
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleStateChanges(
      {required BuildContext context, required MacrosState state}) {
    if (state is MacrosListenerState) {
      switch (state) {
        case TabChangeListenState():
          _selectedTab = state.tab;
          _fetchRecords();
          break;
        case FetchRecordsSuccessListenState():
          _rangeDates = state.rangeDates;
          _dayLogs = state.dayLogs;
          break;
      }
    }
  }

  @override
  void onTabChange(String tab) {
    _bloc.add(DoTabChangeEvent(tab: tab));
  }

  @override
  void onNextTapped() {
    _onDateChanged(1);
  }

  @override
  void onPreviousTapped() {
    _onDateChanged(-1);
  }

  void _fetchRecords() {
    _bloc.add(DoFetchRecordsEvent(
        selectedDateTime: _selectedDateTime, isMonth: _isMonthTab));
  }

  void _onDateChanged(int offset) {
    DateTime newDateTime;

    if (_selectedTab == context.localization?.month) {
      // Handle month change
      newDateTime = DateTime(
        _selectedDateTime.year,
        _selectedDateTime.month + (offset.isNegative ? -1 : 1),
      );
    } else {
      // Handle week change
      newDateTime = offset.isNegative
          ? _selectedDateTime.subtract(const Duration(days: 7))
          : _selectedDateTime.add(const Duration(days: 7));
    }

    _selectedDateTime = newDateTime;
    _fetchRecords();
  }
}
