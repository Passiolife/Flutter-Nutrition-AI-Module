import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/constant/app_constants.dart';
import '../../common/models/day_log/day_log.dart';
import '../../common/models/food_record/food_record_v3.dart';
import '../../common/router/routes.dart';
import '../../common/widgets/bottom_nav_bar_space_widget.dart';
import 'bloc/diary_bloc.dart';
import 'widgets/widgets.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> implements DiaryListener {
  final _bloc = DiaryBloc();

  final DateTime _selectedDate = DateTime.now();
  DayLog? _dayLog;

  @override
  void initState() {
    _bloc.add(FetchRecordsEvent(dateTime: _selectedDate));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DiaryBloc, DiaryState>(
      bloc: _bloc,
      listener: (context, state) {
        _handleStates(context: context, state: state);
      },
      builder: (context, state) {
        return Scaffold(
          // Set background color
          backgroundColor: AppColors.gray50,
          // Prevent the screen from resizing when the keyboard is shown
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              DiaryAppBarWidget(
                selectedDate: _selectedDate,
                onDateTimeChanged: (newDate) {
                  // _bloc.add(DateUpdateEvent(dateTime: newDate));
                },
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.w16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: AppDimens.h24),
                        DailyNutritionWidget(
                          consumedCalories: _dayLog?.consumedCalories,
                          totalCalories: 1200,
                          consumedCarbs: _dayLog?.consumedCarbs,
                          totalCarbs: 150,
                          consumedProteins: _dayLog?.consumedProteins,
                          totalProteins: 90,
                          consumedFat: _dayLog?.consumedFat,
                          totalFat: 27,
                        ),
                        SizedBox(height: AppDimens.h16),
                        MealTileWidget(
                          dayLog: _dayLog,
                          listener: this,
                        ),
                        const BottomNavBarSpaceWidget(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleStates(
      {required BuildContext context, required DiaryState state}) {
    if (state is FetchRecordsSuccessState) {
      _dayLog = state.dayLog;
    }
  }

  @override
  void onEditRecord(FoodRecord record) {
    final index = _dayLog?.records.indexOf(record);
    Navigator.pushNamed(
      context,
      Routes.editFoodPage,
      arguments: {
        AppCommonConstants.data: record.clone(),
        AppCommonConstants.iconHeroTag: '${record.iconId}$index',
        AppCommonConstants.titleHeroTag: '${record.name}$index',
        AppCommonConstants.needsReturn: true,
      },
    );
  }

  @override
  void onDeleteRecord(FoodRecord record) {
  }
}
