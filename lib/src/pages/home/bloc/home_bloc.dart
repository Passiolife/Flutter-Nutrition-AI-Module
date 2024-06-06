import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../nutrition_ai_module.dart';
import '../../../common/external_packages/table_calendar/table_calendar.dart';
import '../../../common/models/day_log/day_log.dart';
import '../../../common/models/day_logs/day_logs.dart';
import '../../../common/util/date_time_utility.dart';
import '../../../common/util/double_extensions.dart';
import '../widgets/typedefs.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  CalendarFormat _calendarFormat = CalendarFormat.week;
  RangeDates? _rangeDates;
  DayLogs? _dayLogs;

  HomeBloc() : super(const HomeInitial()) {
    on<FetchRecordsEvent>(_handleFetchRecordsEvent);
    on<UpdateCalendarFormatEvent>(_handleUpdateCalendarFormatEvent);
  }

  FutureOr<void> _handleFetchRecordsEvent(
      FetchRecordsEvent event, Emitter<HomeState> emit) async {
    if (_rangeDates == null ||
        (_rangeDates != null &&
            !event.dateTime.isBetween(
                from: _rangeDates!.startDate, to: _rangeDates!.endDate))) {
      if (_calendarFormat == CalendarFormat.week) {
        _rangeDates = event.dateTime.weekStartEndDates();
      } else {
        _rangeDates = event.dateTime.monthStartEndDates();
      }
      final result = await _connector.fetchRecords(
        fromDate: _rangeDates!.startDate,
        endDate: _rangeDates!.endDate,
      );
      _dayLogs = DayLogs.from(result);
    }
    final dayLog = _dayLogs?.dayLog.cast<DayLog?>().firstWhere(
          (element) =>
              element?.date.formatToString(format9) ==
              event.dateTime.formatToString(format9),
          orElse: () => null,
        );

    // Fetch consumed water
    double consumedWater =
        await _connector.fetchConsumedWater(dateTime: event.dateTime);
    consumedWater = ((event.weightUnit == MeasurementSystem.imperial)
            ? consumedWater * Conversion.mlToOz.value
            : consumedWater)
        .parseFormatted();

    // Fetch measured weight
    double measuredWeight =
        await _connector.fetchMeasuredWeight(dateTime: event.dateTime);
    measuredWeight = ((event.weightUnit == MeasurementSystem.imperial)
            ? measuredWeight * Conversion.kgToLbs.value
            : measuredWeight)
        .parseFormatted();

    emit(FetchRecordsSuccessState(
      selectedDateTime: event.dateTime,
      format: _calendarFormat,
      dayLogs: _dayLogs,
      rangeDates: _rangeDates,
      dayLog: dayLog,
      consumedWater: consumedWater,
      measuredWeight: measuredWeight,
      needToUpdateSelectedDayLog: event.needToUpdateSelectedDayLog,
    ));
  }

  FutureOr<void> _handleUpdateCalendarFormatEvent(
      UpdateCalendarFormatEvent event, Emitter<HomeState> emit) async {
    _calendarFormat = _calendarFormat == CalendarFormat.week
        ? CalendarFormat.month
        : CalendarFormat.week;
    _rangeDates = null;
    add(FetchRecordsEvent(
        dateTime: event.dateTime, weightUnit: event.weightUnit));
  }
}
