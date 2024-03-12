import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/constant/app_dimens.dart';
import '../../common/models/day_logs/day_logs.dart';
import '../../common/widgets/bottom_nav_bar_space_widget.dart';
import 'bloc/home_bloc.dart';
import 'widgets/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({this.customAppBarKey, super.key});

  final GlobalKey? customAppBarKey;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();
  DayLogs? _dayLogs;

  final _bloc = HomeBloc();

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
              customAppBarKey: widget.customAppBarKey,
              selectedDate: selectedDate,
              onDateTimeChanged: (newDate) {
                selectedDate = newDate;
                _bloc.add(FetchRecordsEvent(dateTime: selectedDate));
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimens.w16),
                  child: Column(
                    children: [
                      SizedBox(height: AppDimens.h16),
                      const DailyNutritionWidget(),
                      SizedBox(height: AppDimens.h16),
                      WeeklyAdherenceWidget(
                        selectedDate: selectedDate,
                        dayLogs: _dayLogs,
                        onPageChanged: (dateTime) {
                          // _bloc.add(FetchRecordsEvent(dateTime: dateTime));
                        },
                      ),
                      SizedBox(height: AppDimens.h16),
                      const MeasurementRow(),
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
    _bloc.add(FetchRecordsEvent(dateTime: selectedDate));
  }

  void _handleStateChanges(
      {required BuildContext context, required HomeState state}) {
    if (state is FetchRecordsSuccessState) {
      _dayLogs = state.dayLogs;
    }
  }
}
