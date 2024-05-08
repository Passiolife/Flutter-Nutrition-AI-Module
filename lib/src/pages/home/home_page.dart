import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/constant/app_dimens.dart';
import '../../common/external_packages/table_calendar/table_calendar.dart';
import '../../common/models/day_log/day_log.dart';
import '../../common/models/day_logs/day_logs.dart';
import '../../common/models/user_profile/user_profile_model.dart';
import '../../common/util/double_extensions.dart';
import '../../common/util/user_session.dart';
import '../../common/widgets/bottom_nav_bar_space_widget.dart';
import 'bloc/home_bloc.dart';
import 'water/water_page.dart';
import 'weight/weight_page.dart';
import 'widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> implements HomeListener {
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();
  DayLogs? _dayLogs;
  DayLog? _selectedDayLog;
  RangeDates? _rangeDates;

  final _bloc = HomeBloc();

  CalendarFormat _calendarFormat = CalendarFormat.week;

  double _consumedWater = 0;
  double _measuredWeight = 0;

  double get _remainingWater =>
      ((_profileModel?.getTargetWater() ?? 0) - _consumedWater) > 0
          ? ((_profileModel?.getTargetWater() ?? 0) - _consumedWater)
              .parseFormatted()
          : 0;

  double get _remainingWeight =>
      ((_profileModel?.getTargetWeight()?.parseFormatted() ?? 0) -
                  _measuredWeight) >
              0
          ? ((_profileModel?.getTargetWeight()?.parseFormatted() ??
                      0) -
                  _measuredWeight)
              .parseFormatted()
          : 0;

  final UserProfileModel? _profileModel = UserSession.instance.userProfile;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: _bloc,
      listener: (context, state) {
        _handleStateChanges(context: context, state: state);
      },
      builder: (context, state) {
        return Column(
          children: [
            HomeAppBarWidget(
              selectedDate: _selectedDate,
              userName: _profileModel?.name,
              listener: this,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.w16),
                  child: Column(
                    children: [
                      SizedBox(height: AppDimens.h16),
                      DailyNutritionWidget(
                        consumedCalories:
                            _selectedDayLog?.consumedCalories.round() ?? 0,
                        totalCalories:
                            _profileModel?.caloriesTarget.toDouble() ?? 0,
                        consumedCarbs:
                            _selectedDayLog?.consumedCarbs.round() ?? 0,
                        totalCarbs:
                            _profileModel?.carbsGram.toDouble() ?? 0,
                        consumedProteins:
                            _selectedDayLog?.consumedProteins.round() ?? 0,
                        totalProteins:
                            _profileModel?.proteinGram.toDouble() ?? 0,
                        consumedFat: _selectedDayLog?.consumedFat.round() ?? 0,
                        totalFat: _profileModel?.fatGram.toDouble() ?? 0,
                      ),
                      SizedBox(height: AppDimens.h16),
                      WeeklyAdherenceWidget(
                        selectedDate: _selectedDate,
                        focusedDate: _focusedDate,
                        calendarFormat: _calendarFormat,
                        dayLogs: _dayLogs,
                        startDateTime: _rangeDates?.startDate,
                        endDateTime: _rangeDates?.endDate,
                        isMonthRange: _calendarFormat == CalendarFormat.month,
                        listener: this,
                      ),
                      SizedBox(height: AppDimens.h16),
                      MeasurementRow(
                        listener: this,
                        consumedWater: _consumedWater,
                        remainingWater: _remainingWater,
                        waterUnit: _profileModel?.weightUnit ==
                                MeasurementSystem.imperial
                            ? WaterUnits.oz.name
                            : WaterUnits.ml.name,
                        measuredWeight: _measuredWeight,
                        remainingWeight: _remainingWeight,
                        weightUnit: _profileModel?.weightUnit ==
                                MeasurementSystem.imperial
                            ? WeightUnits.lbs.name
                            : WeightUnits.kg.name,
                      ),
                      const BottomNavBarSpaceWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  void _initialize() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _doFetchRecords(_selectedDate);
    });
  }

  void _handleStateChanges({
    required BuildContext context,
    required HomeState state,
  }) {
    if (state is FetchRecordsSuccessState) {
      _dayLogs = state.dayLogs;
      if(state.needToUpdateSelectedDayLog) {
        _selectedDayLog = state.dayLog;
      }
      _rangeDates = state.rangeDates;
      _calendarFormat = state.format;
      _consumedWater = state.consumedWater;
      _measuredWeight = state.measuredWeight;
    }
  }

  @override
  void onTapCalendarFormat() {
    _bloc.add(UpdateCalendarFormatEvent(dateTime: _selectedDate, weightUnit: _profileModel?.weightUnit));
    if (_calendarFormat == CalendarFormat.month) {
      _focusedDate = _selectedDate;
    }
  }

  @override
  void onDateChanged(DateTime dateTime, bool changeSelectedDate) {
    bool needToUpdateSelectedDayLog = false;
    if (changeSelectedDate) {
      needToUpdateSelectedDayLog = true;
      _selectedDate = dateTime;
    }
    _focusedDate = dateTime;
    _doFetchRecords(_focusedDate, needToUpdateSelectedDayLog: needToUpdateSelectedDayLog);
  }

  @override
  void onTapWeight() {
    WeightPage.navigate(context).then((value) {
      _doFetchRecords(_focusedDate);
    });
  }

  @override
  void onTapWater() {
    WaterPage.navigate(context).then((value) {
      _doFetchRecords(_focusedDate);
    });
  }

  void _doFetchRecords(DateTime dateTime, {bool needToUpdateSelectedDayLog = true}) {
    _bloc.add(FetchRecordsEvent(dateTime: dateTime, weightUnit: _profileModel?.weightUnit, needToUpdateSelectedDayLog: needToUpdateSelectedDayLog));
  }
}
