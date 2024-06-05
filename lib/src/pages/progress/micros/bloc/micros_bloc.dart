import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../nutrition_ai_module.dart';
import '../../../../common/models/day_log/day_log.dart';

part 'micros_event.dart';
part 'micros_state.dart';

class MicrosBloc extends Bloc<MicrosEvent, MicrosState> {
  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  MicrosBloc() : super(const MicrosInitial()) {
    on<DoFetchRecordsEvent>(_handleDoFetchRecordsEvent);
  }

  FutureOr<void> _handleDoFetchRecordsEvent(
      DoFetchRecordsEvent event, Emitter<MicrosState> emit) async {
    final dateTime = event.selectedDateTime;
    final result = await _connector.fetchDayRecords(dateTime: dateTime);
    final dayLog = DayLog(date: dateTime, records: result);
    emit(FetchRecordsSuccessListenState(dayLog));
    emit(const FetchRecordsSuccessBuildState());
  }
}
