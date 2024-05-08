import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../../nutrition_ai_module.dart';
import '../../../common/models/day_log/day_log.dart';
import '../../../common/models/food_record/meal_label.dart';

part 'diary_event.dart';

part 'diary_state.dart';

class DiaryBloc extends Bloc<DiaryEvent, DiaryState> {
  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  DiaryBloc() : super(DiaryInitial()) {
    on<FetchRecordsEvent>(_handleFetchRecordsEvent);
    on<DoRecordDeleteEvent>(_handleDoRecordDeleteEvent);
    on<FetchSuggestionsEvent>(_handleFetchSuggestionsEvent);
    on<DoLogEvent>(_handleDoLogEvent);
  }

  FutureOr<void> _handleFetchRecordsEvent(
      FetchRecordsEvent event, Emitter<DiaryState> emit) async {
    final result = await _connector.fetchDayRecords(dateTime: event.dateTime);
    final dayLog = DayLog(date: event.dateTime, records: result);
    emit(FetchRecordsSuccessState(dayLog));
  }


  FutureOr<void> _handleDoRecordDeleteEvent(
      DoRecordDeleteEvent event, Emitter<DiaryState> emit) async {
    await _connector.deleteRecord(foodRecord: event.foodRecord);
    emit(RecordDeletedSuccessState(id: event.foodRecord.id));
  }

  FutureOr<void> _handleFetchSuggestionsEvent(FetchSuggestionsEvent event, Emitter<DiaryState> emit) async {
    final mealLabel = MealLabel.dateToMealLabel(DateTime.now());
    final mealTime = PassioMealTime.values.firstWhere((element) => element.name.toLowerCase()==mealLabel.value.toLowerCase());
    final list = await NutritionAI.instance.fetchSuggestions(mealTime);
    emit(FetchSuggestionsSuccessState(data: list));
  }

  Future<void> _handleDoLogEvent(
      DoLogEvent event, Emitter<DiaryState> emit) async {
    if (event.data == null) return;
    PassioFoodItem? foodItem =
    await NutritionAI.instance.fetchFoodItemForDataInfo(event.data!);
    if (foodItem != null) {
      final foodRecord = FoodRecord.fromPassioFoodItem(foodItem);
      await _connector.updateRecord(foodRecord: foodRecord, isNew: true);
    }
    emit(LogSuccessState(createdAt: DateTime.now().millisecondsSinceEpoch));
  }
}
