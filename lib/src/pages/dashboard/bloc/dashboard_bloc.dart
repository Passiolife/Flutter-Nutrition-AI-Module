import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../../nutrition_ai_module.dart';

part 'dashboard_event.dart';

part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  /// [_connector] use to perform operations.
  PassioConnector get _connector => NutritionAIModule.instance.configuration.connector;

  DashboardBloc() : super(DashboardInitial()) {
    on<GetFoodRecordsEvent>(_handleGetFoodLogsEvent);
    on<RefreshFoodRecordEvent>(_handleRefreshFoodLogEvent);
    on<DeleteFoodRecordEvent>(_handleDeleteFoodRecordEvent);
    on<DoFoodInsertEvent>(_handleDoFoodInsertEvent);
    on<DoTabChangeEvent>(_handleDoTabChangeEvent);
  }

  Future _handleGetFoodLogsEvent(GetFoodRecordsEvent event, Emitter<DashboardState> emit) async {
    try {
      final result = await _connector.fetchDayRecords(dateTime: event.dateTime) ?? [];
      emit(GetFoodRecordSuccessState(data: result));
    } catch (e) {
      emit(GetFoodRecordFailureState(message: e.toString()));
    }
  }

  Future<void> _handleRefreshFoodLogEvent(RefreshFoodRecordEvent event, Emitter<DashboardState> emit) async {
    emit(RefreshFoodLogState());
  }

  Future<void> _handleDeleteFoodRecordEvent(DeleteFoodRecordEvent event, Emitter<DashboardState> emit) async {
    try {
      final foodRecord = event.data;
      if (foodRecord == null) {
        emit(FoodInsertFailureState(message: 'Something went wrong while parsing data.'));
        return;
      }
      await _connector.deleteRecord(foodRecord: foodRecord);
    } catch (e) {
      emit(DeleteRecordFailureState(message: e.toString()));
    }
  }

  FutureOr<void> _handleDoFoodInsertEvent(DoFoodInsertEvent event, Emitter<DashboardState> emit) async {
    try {
      if (event.data?.passioID.isNotEmpty ?? false) {
        // Get attribute data from SDK.
        final attributes = await NutritionAI.instance.lookupPassioAttributesFor(event.data?.passioID ?? '');

        if (attributes == null) {
          emit(FoodInsertFailureState(message: 'Something went wrong while parsing data.'));
          return;
        }

        // Convert passio attribute to food record.
        final foodRecord = FoodRecord.from(passioIDAttributes: attributes, dateTime: event.dateTime);

        await _connector.updateRecord(foodRecord: foodRecord, isNew: true);
        emit(FoodInsertSuccessState());
      }
    } catch (e) {
      emit(FoodInsertFailureState(message: e.toString()));
    }
  }

  FutureOr<void> _handleDoTabChangeEvent(DoTabChangeEvent event, Emitter<DashboardState> emit) {
    emit(TabChangedState(tab: event.tab));
  }
}
