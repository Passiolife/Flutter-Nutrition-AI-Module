import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../nutrition_ai_module.dart';
import '../../../common/models/day_logs/day_logs.dart';
import '../../../common/util/date_time_utility.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  HomeBloc() : super(HomeInitial()) {
    on<FetchRecordsEvent>(_handleFetchRecordsEvent);
  }

  Future<FutureOr<void>> _handleFetchRecordsEvent(
      FetchRecordsEvent event, Emitter<HomeState> emit) async {
    final rangeDates = event.dateTime.weekStartEndDates();
    final result = await _connector.fetchRecords(
        fromDate: rangeDates.startDate, endDate: rangeDates.endDate);
    /*final dayLogs = [];//DayLogs.from(result);

    emit(FetchRecordsSuccessState(dayLogs));*/
  }
}
