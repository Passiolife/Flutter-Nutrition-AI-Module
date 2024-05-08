import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../nutrition_ai_module.dart';
import '../../../../common/models/day_log/day_log.dart';
import '../../../../common/models/day_logs/day_logs.dart';
import '../../../../common/util/date_time_utility.dart';
import '../../../../common/widgets/typedefs.dart';

part 'macros_event.dart';
part 'macros_state.dart';

class MacrosBloc extends Bloc<MacrosEvent, MacrosState> {
  final _connector = NutritionAIModule.instance.configuration.connector;

  MacrosBloc() : super(const MacrosInitial()) {
    on<DoTabChangeEvent>(_handleDoTabChangeEvent);
    on<DoFetchRecordsEvent>(_handleDoFetchRecordsEvent);
  }

  Future<void> _handleDoTabChangeEvent(
      DoTabChangeEvent event, Emitter<MacrosState> emit) async {
    emit(TabChangeListenState(tab: event.tab));
  }

  Future<void> _handleDoFetchRecordsEvent(
      DoFetchRecordsEvent event, Emitter<MacrosState> emit) async {
    RangeDates? rangeDates;
    if (event.isMonth) {
      rangeDates = event.selectedDateTime.monthStartEndDates();
    } else {
      rangeDates =
          event.selectedDateTime.weekStartEndDates(weekDay: DateTime.monday);
    }
    final records = await _connector.fetchRecords(
        fromDate: rangeDates.startDate, endDate: rangeDates.endDate);
    final dayLogs = DayLogs.from(records);
    addEmptyDates(rangeDates, dayLogs);

    emit(FetchRecordsSuccessListenState(
      rangeDates: rangeDates,
      dayLogs: dayLogs,
    ));
    emit(const FetchRecordsSuccessBuildState());
  }

  void addEmptyDates(RangeDates rangeDates, DayLogs dayLogs) {
    final dates =
        rangeDates.startDate.getDatesBetween(endDate: rangeDates.endDate) ?? [];
    for (var date in dates) {
      if (!dayLogs.dayLog.any((log) => log.date == date)) {
        dayLogs.dayLog.add(DayLog(date: date));
      }
    }
    dayLogs.dayLog.sort((a, b) => a.date.compareTo(b.date));
  }
}
