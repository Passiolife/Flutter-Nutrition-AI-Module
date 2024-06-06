import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../nutrition_ai_module.dart';
import '../../../../common/models/water_day_logs/water_day_logs.dart';
import '../../../../common/util/date_time_utility.dart';
import '../../../../common/widgets/typedefs.dart';

part 'water_event.dart';
part 'water_state.dart';

class WaterBloc extends Bloc<WaterEvent, WaterState> {
  final _connector = NutritionAIModule.instance.configuration.connector;
  RangeDates? _rangeDates;

  WaterBloc() : super(const WaterInitial()) {
    on<FetchRecordsEvent>(_handleFetchRecordsEvent);
    on<QuickAddEvent>(_handleQuickAddEvent);
    on<DoDeleteLogEvent>(_handleDoDeleteLogEvent);
  }

  FutureOr<void> _handleFetchRecordsEvent(
      FetchRecordsEvent event, Emitter<WaterState> emit) async {
    if (event.isMonth) {
      _rangeDates = event.dateTime.monthStartEndDates();
    } else {
      _rangeDates = event.dateTime.weekStartEndDates(weekDay: DateTime.monday);
    }
    if (_rangeDates == null) return;
    final records = await _connector.fetchWaterRecords(
        fromDate: _rangeDates!.startDate, endDate: _rangeDates!.endDate);
    final dayLogs = WaterDayLogs.from(records);
    dayLogs.fromDates(
        _rangeDates?.startDate.getDatesBetween(endDate: _rangeDates!.endDate) ??
            []);
    emit(FetchRecordsSuccessState(rangeDates: _rangeDates, dayLogs: dayLogs));
  }

  Future<void> _handleQuickAddEvent(
      QuickAddEvent event, Emitter<WaterState> emit) async {
    DateTime createdAt = DateTime.now();
    WaterRecord record = WaterRecord(
      // waterConsumption: event.consumedWater,
      createdAt: createdAt.toUtc().millisecondsSinceEpoch,
    );
    record.setWater(event.consumedWater, event.unit);
    await _connector.updateWater(waterRecord: record, isNew: true);
    emit(const QuickAddSuccessState());
  }

  Future<void> _handleDoDeleteLogEvent(
      DoDeleteLogEvent event, Emitter<WaterState> emit) async {
    await _connector.deleteWaterRecord(record: event.record);
    emit(const DeleteLogSuccessState());
  }
}
