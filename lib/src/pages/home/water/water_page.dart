import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/models/user_profile/user_profile_model.dart';
import '../../../common/models/water_day_log/water_day_log.dart';
import '../../../common/models/water_day_logs/water_day_logs.dart';
import '../../../common/models/water_record/water_record.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/date_time_utility.dart';
import '../../../common/util/double_extensions.dart';
import '../../../common/util/snackbar_extension.dart';
import '../../../common/util/user_session.dart';
import '../../../common/widgets/typedefs.dart';
import 'add_water/add_water_page.dart';
import 'bloc/water_bloc.dart';
import 'widgets/widgets.dart';

class WaterPage extends StatefulWidget {
  const WaterPage({super.key});

  static Future navigate(BuildContext context) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WaterPage(),
      ),
    );
  }

  @override
  State<WaterPage> createState() => _WaterPageState();
}

class _WaterPageState extends State<WaterPage>
    implements
        WaterListener,
        TabChangeListener,
        RangeDateListener,
        MeasurementAppBarListener,
        EntryTileListener {
  // Properties
  List<String?> get _tabs =>
      [context.localization?.week, context.localization?.month];

  String? _selectedTab;

  DateTime _selectedDateTime = DateTime.now();

  RangeDates? _rangeDates;

  bool get isMonthTab => _selectedTab != null && _selectedTab != _tabs.first;

  final _bloc = WaterBloc();

  WaterDayLogs? _dayLogs;

  final _profileModel = UserSession.instance.userProfile;

  // Getters
  double get _remainingWater => (targetWater -
              (_dayLogs?.getConsumedWater(_profileModel?.weightUnit ??
                      MeasurementSystem.imperial) ??
                  0)) >
          0
      ? targetWater -
          (_dayLogs?.getConsumedWater(
                  _profileModel?.weightUnit ?? MeasurementSystem.imperial) ??
              0)
      : 0;

  // Trend Widget Related properties

  String get _trendTitle => context.localization?.waterTrend ?? '';

  double get chartMaximumValue =>
      _dayLogs?.dayLog
          .fold<WaterDayLog?>(
              null,
              (previousValue, element) => (previousValue?.getConsumedWater(
                              _profileModel?.weightUnit ??
                                  MeasurementSystem.imperial) ??
                          0) >
                      element.getConsumedWater(_profileModel?.weightUnit ??
                          MeasurementSystem.imperial)
                  ? previousValue
                  : element)
          ?.getConsumedWater(
              _profileModel?.weightUnit ?? MeasurementSystem.imperial) ??
      0;

  double get targetWater => ((_profileModel?.getTargetWater() ?? 0) *
      (_rangeDates != null
          ? _rangeDates!.startDate.daysBetween(_rangeDates!.endDate) + 1
          : 0));

  double get maximumValue => max(max(chartMaximumValue, targetWater), 5);

  List<ChartData> get _chartData =>
      _dayLogs?.dayLog
          .map((e) => ChartData(
                (_selectedTab == _tabs.firstOrNull)
                    ? e.date.formatToString(format10).substring(0, 2)
                    : e.date.formatToString(format16),
                e.getConsumedWater(
                    _profileModel?.weightUnit ?? MeasurementSystem.imperial),
              ))
          .toList() ??
      [];

  final PageController _pageController = PageController();

  List<WaterRecord> get _records =>
      _dayLogs?.dayLog.expand((element) => element.records).toList() ?? [];

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _selectedTab = _tabs.firstOrNull;
      _fetchRecords();
    });
  }

  void _fetchRecords({bool isFirstTime = true}) {
    _bloc.add(FetchRecordsEvent(
      dateTime: _selectedDateTime,
      isMonth: _selectedTab == context.localization?.month,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WaterBloc, WaterState>(
      bloc: _bloc,
      listener: (context, state) {
        _handleStateChanges(context: context, state: state);
      },
      buildWhen: (_, state) {
        return state is FetchRecordsSuccessState;
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.gray50,
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              MeasurementAppBar(
                title: context.localization?.water,
                listener: this,
              ),
              SizedBox(height: AppDimens.h24),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.w16),
                  child: Column(
                    children: [
                      SubTabBar(
                        tabs: _tabs,
                        selectedTab: _selectedTab ?? _tabs.firstOrNull,
                        onTabChange: this,
                      ),
                      40.verticalSpace,
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (page) {
                            _doTabChange(_tabs.elementAt(page) ?? '');
                          },
                          children: List.generate(
                            2,
                            (index) {
                              return Column(
                                children: [
                                  RangeDateNavigatorWidget(
                                    startDateTime: _rangeDates?.startDate ??
                                        DateTime.now(),
                                    endDateTime:
                                        _rangeDates?.endDate ?? DateTime.now(),
                                    listener: this,
                                    isMonthRange: isMonthTab,
                                  ),
                                  Expanded(
                                    child: ListView(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.only(top: 32.h),
                                      children: [
                                        TrendWidget(
                                          title: _trendTitle,
                                          centerWidget: WaterTrendGraph(
                                            maximumValue: maximumValue,
                                            targetValue: targetWater,
                                            chartData: _chartData,
                                          ),
                                          consumed: _dayLogs
                                                  ?.getConsumedWater(
                                                      _profileModel
                                                              ?.weightUnit ??
                                                          MeasurementSystem
                                                              .imperial)
                                                  .parseFormatted() ??
                                              0,
                                          remaining: _remainingWater,
                                          unit: _profileModel?.weightUnit ==
                                                  MeasurementSystem.imperial
                                              ? WaterUnits.oz.name
                                              : WaterUnits.ml.name,
                                        ),
                                        SizedBox(height: AppDimens.h16),
                                        QuickAddWidget(
                                          listener: this,
                                          unit: _profileModel?.weightUnit,
                                        ),
                                        SizedBox(height: AppDimens.h16),
                                        _records.isNotEmpty
                                            ? EntryTileWidget(
                                                isMonthRange: isMonthTab,
                                                rangeDates: _rangeDates,
                                                data: _records
                                                    .map(
                                                      (e) => EntryTileChildData(
                                                        id: e.id ?? -1,
                                                        value: e
                                                            .getWater(
                                                                unit: _profileModel
                                                                        ?.weightUnit ??
                                                                    MeasurementSystem
                                                                        .imperial)
                                                            .format(),
                                                        unit: _profileModel
                                                                    ?.weightUnit ==
                                                                MeasurementSystem
                                                                    .imperial
                                                            ? context
                                                                    .localization
                                                                    ?.oz ??
                                                                ''
                                                            : context
                                                                    .localization
                                                                    ?.ml ??
                                                                '',
                                                        dateTime:
                                                            DateTime.now(),
                                                      ),
                                                    )
                                                    .toList(),
                                                listener: this,
                                              )
                                            : const SizedBox.shrink(),
                                        SizedBox(height: AppDimens.h40),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void onTapAdd() {
    AddWaterPage.navigate(context: context).then((value) {
      if (value is bool? && (value ?? false)) {
        context.showSnackbar(text: context.localization?.waterRecorded);
        _fetchRecords();
      }
    });
  }

  @override
  void onTabChange(String tab) {
    _pageController.animateToPage(_tabs.indexOf(tab),
        duration: const Duration(milliseconds: 250), curve: Curves.linear);
  }

  void _handleStateChanges({
    required BuildContext context,
    required WaterState state,
  }) {
    if (state is FetchRecordsSuccessState) {
      _rangeDates = state.rangeDates;
      _dayLogs = state.dayLogs;
    } else if (state is QuickAddSuccessState) {
      context.showSnackbar(text: context.localization?.waterRecorded);
      _fetchRecords();
    } else if (state is DeleteLogSuccessState) {
      context.showSnackbar(
          text: context.localization?.waterRecordDeleteMessage);
      _fetchRecords();
    }
  }

  @override
  void onTapQuickAdd(double water) {
    _bloc.add(QuickAddEvent(
        consumedWater: water,
        unit: _profileModel?.weightUnit ?? MeasurementSystem.imperial));
  }

  @override
  void onDeleteLog(int id) {
    final record = _dayLogs?.dayLog
        .expand((element) => element.records)
        .cast<WaterRecord?>()
        .firstWhere((element) => element?.id == id, orElse: () => null);
    if (record != null) {
      _bloc.add(DoDeleteLogEvent(record: record));
    }
  }

  @override
  void onEditLog(int id) {
    final record = _dayLogs?.dayLog
        .expand((element) => element.records)
        .cast<WaterRecord?>()
        .firstWhere((element) => element?.id == id, orElse: () => null);
    AddWaterPage.navigate(context: context, record: record).then((value) {
      if (value is bool? && (value ?? false)) {
        context.showSnackbar(
            text: context.localization?.waterRecordUpdateMessage);
        _fetchRecords();
      }
    });
  }

  @override
  void onNextTapped() {
    _onDateChanged(1);
  }

  @override
  void onPreviousTapped() {
    _onDateChanged(-1);
  }

  void _doTabChange(String tab) {
    _selectedDateTime = DateTime.now();
    _selectedTab = tab;
    _fetchRecords();
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
    _fetchRecords(isFirstTime: false);
  }
}
