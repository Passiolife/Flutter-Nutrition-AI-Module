import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../nutrition_ai_module.dart';
import '../../../../common/models/weight_day_logs/weight_day_logs.dart';
import '../../../../common/util/date_time_utility.dart';
import '../../../../common/widgets/typedefs.dart';

part 'weight_event.dart';
part 'weight_state.dart';

class WeightBloc extends Bloc<WeightEvent, WeightState> {
  RangeDates? _rangeDates;
  final _connector = NutritionAIModule.instance.configuration.connector;

  WeightBloc() : super(const WeightInitial()) {
    on<FetchRecordsEvent>(_handleFetchRecordsEvent);
    on<DoDeleteLogEvent>(_handleDoDeleteLogEvent);
  }

  Future<void> _handleFetchRecordsEvent(
      FetchRecordsEvent event, Emitter<WeightState> emit) async {
    /*if (event.isMonth) {
      _rangeDates = event.dateTime.monthStartEndDates();
    } else {
      _rangeDates = event.dateTime.weekStartEndDates(weekDay: DateTime.monday);
    }
    if (_rangeDates == null) return;*/
    final startDate = event.startDate;
    final endDate = event.endDate;
    final records = await _connector.fetchWeightRecords(
        fromDate: startDate, endDate: endDate);
    final dayLogs = WeightDayLogs.from(records);
    dayLogs.fromDates(startDate.getDatesBetween(endDate: endDate));
    emit(FetchRecordsSuccessState(
      rangeDates: _rangeDates,
      dayLogs: dayLogs,
    ));
  }

  Future<void> _handleDoDeleteLogEvent(
      DoDeleteLogEvent event, Emitter<WeightState> emit) async {
    await _connector.deleteWeightRecord(record: event.record);
    emit(const DeleteLogSuccessState());
  }
}
