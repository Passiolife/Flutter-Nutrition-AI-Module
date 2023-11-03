import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../common/constant/app_colors.dart';
import '../../common/constant/app_images.dart';
import '../../common/constant/dimens.dart';
import '../../common/constant/styles.dart';
import '../../common/models/time_log/time_log.dart';
import '../../common/util/context_extension.dart';
import '../../common/util/double_extensions.dart';
import '../../common/util/user_session.dart';
import 'bloc/progress_bloc.dart';
import 'enum/progress_enums.dart';
import 'widgets/donut_chart.dart';
import 'widgets/stacked_calorie_chart.dart';
import 'widgets/stacked_macro_chart.dart';

class ProgressPage extends StatefulWidget {
  const ProgressPage({super.key});

  static void navigate(BuildContext context, DateTime dateTime) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressPage()));
  }

  @override
  State<ProgressPage> createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  /// [_bloc] is use to fire the appropriate event and bloc will emit the state.
  /// So based on that we will display the widget.
  final _bloc = ProgressBloc();

  /// [_tabs] contains the list of time in localize string
  /// So based on that we will display the widget.
  List<String> get _tabs => [
        context.localization?.day ?? '',
        context.localization?.week ?? '',
        context.localization?.month ?? '',
      ];

  /// [_selectedTime] stores the selected time enum.
  /// If use has selected [week] from [_tabs] then [_selectedTime] contains [TimeEnum.week] value.
  TimeEnum? _selectedTime;

  /// [_selectedDays] is use to calculate with macros.
  int _selectedDays = 1;

  List<TimeLog> _timeLog = [];

  // Calories related things.
  /// [_consumedCalories] contains the consumed calories.
  double get _consumedCalories => _timeLog.isNotEmpty
      ? _timeLog.map((e) => e.foodRecords.isNotEmpty ? e.totalCalories : 0.0).reduce((value, element) => (value) + (element)).roundNumber(1)
      : 0;

  // Calories: END

  // Carbs related things.
  /// [_consumedCarbs] contains the consumed carbs.
  double get _consumedCarbs => _timeLog.isNotEmpty
      ? _timeLog.map((e) => e.foodRecords.isNotEmpty ? e.totalCarbs : 0.0).reduce((value, element) => (value) + (element)).roundNumber(1)
      : 0;

  // Carbs: END

  // Fat related things.
  /// [_consumedFats] contains the consumed fats.
  double get _consumedFats => _timeLog.isNotEmpty
      ? _timeLog.map((e) => e.foodRecords.isNotEmpty ? e.totalFat : 0.0).reduce((value, element) => (value) + (element)).roundNumber(1)
      : 0;

  // Fat: END

  // Proteins related things.
  /// [_consumedProteins] contains the consumed proteins.
  double get _consumedProteins => _timeLog.isNotEmpty
      ? _timeLog.map((e) => e.foodRecords.isNotEmpty ? e.totalProteins : 0.0).reduce((value, element) => (value) + (element)).roundNumber(1)
      : 0;

  // Proteins: END

  // [_userSession] contains the user information and profile.
  final _userSession = UserSession.instance;

  final bool _isAbsoluteValue = true;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _bloc,
      listener: (context, state) {
        if (state is TimeUpdateSuccessState) {
          _handleCalendarChangeState(state: state);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.passioBackgroundWhite,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.passioBackgroundWhite,
            automaticallyImplyLeading: false,
            leading: FittedBox(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(Dimens.r8),
                  child: Image.asset(
                    AppImages.icCancelCircle,
                    width: Dimens.r16,
                    height: Dimens.r16,
                  ),
                ),
              ),
            ),
          ),
          body: ListView(
            children: [
              Dimens.h16.verticalSpace,

              /// Tabs on top for day, week & month.
              Container(
                width: double.maxFinite,
                padding: EdgeInsets.symmetric(horizontal: Dimens.w8),
                child: CupertinoSlidingSegmentedControl<String>(
                  // This represents the currently selected segmented control.
                  groupValue: _selectedTime?.name,
                  // backgroundColor: AppColors.passioBlack25,
                  thumbColor: AppColors.customBase,
                  children: {
                    for (var v in _tabs)
                      (v).toLowerCase(): Container(
                        margin: EdgeInsets.all(Dimens.r12),
                        child: Text(
                          v,
                          style: AppStyles.style12
                              .copyWith(color: _selectedTime?.name.toLowerCase() == (v).toLowerCase() ? AppColors.passioInset : AppColors.blackColor),
                        ),
                      )
                  },
                  onValueChanged: (value) {
                    _bloc.add(DoCalendarChangeEvent(time: value));
                  },
                ),
              ),

              Dimens.h16.verticalSpace,

              // Donut Graphs for calories, carbs, fat & proteins.
              SizedBox(
                width: double.maxFinite,
                height: 200,
                child: ClipRRect(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimens.w8),
                    child: Row(
                      children: [
                        Expanded(
                          child: DonutChart(
                            totalValue: (_userSession.userProfile?.caloriesTarget ?? 0) * _selectedDays,
                            value: _consumedCalories,
                            centerValue: '${_consumedCalories.toInt()}g',
                            progressColor: AppColors.chartColorGOrange,
                            title: context.localization?.calories ?? '',
                            targetValue: '${(_userSession.userProfile?.caloriesTarget ?? 0) * _selectedDays}g',
                          ),
                        ),
                        Dimens.w16.horizontalSpace,
                        Expanded(
                          child: DonutChart(
                            totalValue: (_userSession.userProfile?.carbsGrams ?? 0) * _selectedDays,
                            value: _consumedCarbs,
                            centerValue: '${_consumedCarbs.toInt()}g',
                            progressColor: AppColors.chartColorGBlue,
                            title: context.localization?.carbs ?? '',
                            targetValue: '${(_userSession.userProfile?.carbsGrams ?? 0) * _selectedDays}g',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Dimens.h8.verticalSpace,
              SizedBox(
                width: double.maxFinite,
                height: 200,
                child: ClipRRect(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Dimens.w8),
                    child: Row(
                      children: [
                        Expanded(
                          child: DonutChart(
                            totalValue: (_userSession.userProfile?.fatGrams ?? 0) * _selectedDays,
                            value: _consumedFats,
                            centerValue: '${_consumedFats.toInt()}g',
                            progressColor: AppColors.chartColorGRed,
                            title: context.localization?.fat ?? '',
                            targetValue: '${(_userSession.userProfile?.fatGrams ?? 0) * _selectedDays}g',
                          ),
                        ),
                        Dimens.w16.horizontalSpace,
                        Expanded(
                          child: DonutChart(
                            totalValue: (_userSession.userProfile?.proteinGrams ?? 0) * _selectedDays,
                            value: _consumedProteins,
                            centerValue: '${_consumedProteins.toInt()}g',
                            progressColor: AppColors.chartColorGGreen,
                            title: context.localization?.protein ?? '',
                            targetValue: '${(_userSession.userProfile?.proteinGrams ?? 0) * _selectedDays}',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Dimens.h8.verticalSpace,

              // Stacked Column Charts for calories.
              Padding(
                padding: EdgeInsets.all(Dimens.r8),
                child: SizedBox(
                  height: Dimens.h214,
                  child: StackedCalorieChart(
                    key: UniqueKey(),
                    timeLog: _timeLog,
                    isAbsoluteValue: _isAbsoluteValue,
                  ),
                ),
              ),

              // Stacked Column Charts for macros.
              Padding(
                padding: EdgeInsets.all(Dimens.r8),
                child: SizedBox(
                  height: Dimens.h214,
                  child: StackedMacroChart(
                    key: UniqueKey(),
                    timeLog: _timeLog,
                    isAbsoluteValue: _isAbsoluteValue,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _initialize() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _bloc.add(DoCalendarChangeEvent(time: _tabs.first));
    });
  }

  void _handleCalendarChangeState({required TimeUpdateSuccessState state}) {
    _selectedTime = state.selectedTimeEnum;
    _selectedDays = state.selectedDays;
    _timeLog = state.data;
  }
}
