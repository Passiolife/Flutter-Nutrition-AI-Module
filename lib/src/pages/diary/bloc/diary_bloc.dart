import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../nutrition_ai_module.dart';
import '../../../common/models/day_log/day_log.dart';

part 'diary_event.dart';
part 'diary_state.dart';

class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  DiaryBloc() : super(DiaryInitial()) {
    on<FetchRecordsEvent>(_handleFetchRecordsEvent);
    on<DoLogEditEvent>(_handleDoLogEditEvent);
    on<DoLogDeleteEvent>(_handleDoLogDeleteEvent);
  }

  FutureOr<void> _handleFetchRecordsEvent(
      FetchRecordsEvent event, Emitter<DiaryState> emit) async {
    final result = await _connector.fetchDayRecords(dateTime: event.dateTime);
    final dayLog = DayLog(date: event.dateTime, records: result);
    emit(FetchRecordsSuccessState(dayLog));
  }

  FutureOr<void> _handleDoLogEditEvent(
      DoLogEditEvent event, Emitter<DiaryState> emit) async {}

  FutureOr<void> _handleDoLogDeleteEvent(
      DoLogDeleteEvent event, Emitter<DiaryState> emit) async {}
}
