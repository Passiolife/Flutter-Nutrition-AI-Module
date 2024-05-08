import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/models/user_profile/user_profile_model.dart';
import '../../../common/models/weight_day_log/weight_day_log.dart';
import '../../../common/models/weight_day_logs/weight_day_logs.dart';
import '../../../common/models/weight_record/weight_record.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/date_time_utility.dart';
import '../../../common/util/double_extensions.dart';
import '../../../common/util/snackbar_extension.dart';
import '../../../common/util/user_session.dart';
import '../../../common/widgets/range_date_navigator_widget.dart';
import '../../../common/widgets/trend_widget.dart';
import '../../../common/widgets/typedefs.dart';
import 'bloc/weight_bloc.dart';
import 'widgets/weight_trend_graph_widget.dart';
import 'widgets/widgets.dart';

class WeightPage extends StatefulWidget {
  const WeightPage({super.key});

  static Future navigate(BuildContext context) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const WeightPage(),
      ),
    );
  }

  @override
  State<WeightPage> createState() => _WeightPageState();
}

class _WeightPageState extends State<WeightPage>
    implements
        MeasurementAppBarListener,
        TabChangeListener,
        RangeDateListener,
        EntryTileListener {
  List<String?> get _tabs =>
      [context.localization?.week, context.localization?.month];

  String? _selectedTab;

  final PageController _pageController = PageController();

  RangeDates? _rangeDates;

  DateTime _selectedDateTime = DateTime.now();

  final _bloc = WeightBloc();

  WeightDayLogs? _dayLogs;

  final _profileModel = UserSession.instance.userProfile;

  List<WeightRecord> get _records =>
      _dayLogs?.dayLog.expand((element) => element.records).toList() ?? [];

  String get _trendTitle => context.localization?.weightTrend ?? '';


  double get _targetWeight => UserSession.instance.userProfile?.getTargetWeight() ?? 0;

  String get _unitSymbol => _profileModel?.weightUnit ==
      MeasurementSystem.imperial
      ? WeightUnits.lbs.name
      : WeightUnits.kg.name;


  @override
  void onTapAdd() {
    AddWeightPage.navigate(context: context).then((value) {
      if (value is bool? && (value ?? false)) {
        context.showSnackbar(text: context.localization?.weightRecorded);
        _fetchRecords();
      }
    });
  }

  @override
  void onTabChange(String tab) {
    _pageController.jumpToPage(_tabs.indexOf(tab));
  }

  @override
  void onNextTapped() {
    _onDateChanged(1);
  }

  @override
  void onPreviousTapped() {
    _onDateChanged(-1);
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _selectedTab = _tabs.firstOrNull;
      _fetchRecords();
      _pageController.addListener(() {
        _pageController.page;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeightBloc, WeightState>(
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
                title: context.localization?.weight,
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
                                    isMonthRange: _selectedTab != null &&
                                        _selectedTab != _tabs.first,
                                  ),
                                  Expanded(
                                    child: ListView(
                                      shrinkWrap: true,
                                      padding: EdgeInsets.only(top: 32.h),
                                      children: [
                                        TrendWidget(
                                          title: _trendTitle,
                                          centerWidget: WeightTrendGraph(
                                            maximumValue: _getMaximumValue(),
                                            targetValue: _targetWeight,
                                            chartData: _getChartData(),
                                          ),
                                          consumedTitle: context
                                              .localization?.currentWeight,
                                          consumed:
                                              _dayLogs?.getMeasuredWeight(_profileModel?.weightUnit) ?? 0,
                                          remaining: _remainingWeight(),
                                          unit: _unitSymbol,
                                        ),
                                        SizedBox(height: AppDimens.h16),
                                        _records.isNotEmpty
                                            ? EntryTileWidget(
                                                isMonthRange: _selectedTab !=
                                                        null &&
                                                    _selectedTab != _tabs.first,
                                                rangeDates: _rangeDates,
                                                data: _records
                                                    .map(
                                                      (e) => EntryTileChildData(
                                                        id: e.id ?? -1,
                                                        value:
                                                            e.getWeight(unit: _profileModel?.weightUnit).format(),
                                                        unit: _unitSymbol,
                                                        dateTime: DateTime
                                                            .fromMillisecondsSinceEpoch(
                                                                e.createdAt),
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

  void _fetchRecords({bool isFirstTime = true}) {
    _bloc.add(FetchRecordsEvent(
      dateTime: _selectedDateTime,
      isMonth: _selectedTab == context.localization?.month,
    ));
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

  void _handleStateChanges(
      {required BuildContext context, required WeightState state}) {
    if (state is FetchRecordsSuccessState) {
      _rangeDates = state.rangeDates;
      _dayLogs = state.dayLogs;
    } else if (state is DeleteLogSuccessState) {
      context.showSnackbar(
          text: context.localization?.weightRecordDeleteMessage);
      _fetchRecords();
    }
  }

  @override
  void onDeleteLog(int id) {
    final record = _dayLogs?.dayLog
        .expand((element) => element.records)
        .cast<WeightRecord?>()
        .firstWhere((element) => element?.id == id, orElse: () => null);
    if (record != null) {
      _bloc.add(DoDeleteLogEvent(record: record));
    }
  }

  @override
  void onEditLog(int id) {
    final record = _dayLogs?.dayLog
        .expand((element) => element.records)
        .cast<WeightRecord?>()
        .firstWhere((element) => element?.id == id, orElse: () => null);
    AddWeightPage.navigate(context: context, record: record).then((value) {
      if (value is bool? && (value ?? false)) {
        context.showSnackbar(
            text: context.localization?.weightRecordUpdateMessage);
        _fetchRecords();
      }
    });
  }

  double _getMaximumValue() => max(max(_chartMaximumValue(), _targetWeight), 5);

  double _remainingWeight() {
    return (_targetWeight - (_dayLogs?.getMeasuredWeight(_profileModel?.weightUnit) ?? 0)) > 0
        ? (_targetWeight - (_dayLogs?.getMeasuredWeight(_profileModel?.weightUnit) ?? 0)).parseFormatted()
        : 0;
  }

  List<ChartData> _getChartData() {
    return _dayLogs?.dayLog
        .map((e) => ChartData(
      (_selectedTab == _tabs.firstOrNull)
          ? e.date.formatToString(format10).substring(0, 2)
          : e.date.formatToString(format16),
      e.getMeasuredWeight(_profileModel?.weightUnit),
    ))
        .toList() ??
        [];
  }


  double _chartMaximumValue() {
    return _dayLogs?.dayLog
        .fold<WeightDayLog?>(
        null,
            (previousValue, element) =>
        (previousValue?.getMeasuredWeight(_profileModel?.weightUnit) ?? 0) >
            element.getMeasuredWeight(_profileModel?.weightUnit)
            ? previousValue
            : element)
        ?.getMeasuredWeight(_profileModel?.weightUnit) ??
        0;
  }
}
