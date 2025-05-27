import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/models/day_logs/day_logs.dart';
import '../bloc_/home_bloc.dart';
import '../widgetss/weekly_adherence_widget.dart';

class WeeklyAdherenceSection extends StatelessWidget {
  const WeeklyAdherenceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (_, state) {
        return state is HomeInitial || state is UpdateWeeklyAdherenceState;
      },
      builder: (context, state) {
        DateTime selectedDate = DateTime.now();
        DateTime focusedDate = DateTime.now();
        DayLogs? dayLogs;
        if (state is UpdateWeeklyAdherenceState) {
          selectedDate = state.selectedDate;
          focusedDate = state.focusedDate;
          dayLogs = state.dayLogs;
        }
        return WeeklyAdherenceWidget(
          selectedDate: selectedDate,
          focusedDate: focusedDate,
          dayLogs: dayLogs,
          onSelectorChanged: (focusedDate, startDate, endDate) =>
              _onSelectorChanged(
            context: context,
            focusedDate: focusedDate,
            startDate: startDate,
            endDate: endDate,
          ),
        );
      },
    );
  }

  void _onSelectorChanged({
    required BuildContext context,
    required DateTime focusedDate,
    required DateTime startDate,
    required DateTime endDate,
  }) {
    context.read<HomeBloc>().add(UpdateWeeklyAdherenceEvent(
          focusedDate: focusedDate,
          startDate: startDate,
          endDate: endDate,
        ));
  }
}
