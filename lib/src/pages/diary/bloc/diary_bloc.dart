import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../nutrition_ai_module.dart';
import '../../../common/models/day_log/day_log.dart';
import '../../../common/models/food_record/meal_label.dart';
import '../../../common/models/quick_suggestion/quick_suggestion.dart';
import '../../../common/util/iterable_extension.dart';

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

    add(const FetchSuggestionsEvent());
  }

  FutureOr<void> _handleFetchSuggestionsEvent(
      FetchSuggestionsEvent event, Emitter<DiaryState> emit) async {
    final mealLabel = MealLabel.dateToMealLabel(DateTime.now());

    // Get current date and calculate start date 30 days ago
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 30));

    // Fetch logged food records within the last 30 days and remove duplicates
    final loggedFoodRecords = await _connector.fetchRecords(
      fromDate: startDate,
      endDate: endDate,
    );

    final foodRecords =
        QuickSuggestion.fromFoodRecords(mealLabel, loggedFoodRecords);

    // Get meal label and determine meal time
    final mealTime = PassioMealTime.values.firstWhere((element) =>
        element.name.toLowerCase() == mealLabel.value.toLowerCase());

    // Fetch nutrition suggestions based on meal time
    final suggestions = await NutritionAI.instance.fetchSuggestions(mealTime);

    final suggestionRecords =
        QuickSuggestion.fromPassioFoodDataInfo(suggestions);
    foodRecords.addAll(suggestionRecords);

    final uniqueRecords = foodRecords
        .distinct(
            by: (record) =>
                record.foodRecord?.name.toLowerCase() ??
                record.passioFoodDataInfo?.foodName.toLowerCase())
        .toList();

    final result = await _connector.fetchDayRecords(dateTime: endDate);
    final dayLog = DayLog(date: endDate, records: result);
    final foodNamesInData = dayLog
        .getFoodRecordByMeal(mealLabel)
        .map((e) => e.name.toLowerCase())
        .toList();

    uniqueRecords.removeWhere((record) {
      final name = record.foodRecord?.name.toLowerCase() ??
          record.passioFoodDataInfo?.foodName.toLowerCase();
      return foodNamesInData.contains(name);
    });

    // Take the first 30 suggestions
    final suggestedData = uniqueRecords.take(30).toList();

    // Emit success state with data
    emit(FetchSuggestionsSuccessState(data: suggestedData));
  }

  Future<void> _handleDoLogEvent(
      DoLogEvent event, Emitter<DiaryState> emit) async {
    final suggestion = event.data;
    if (suggestion == null) return;
    if (suggestion.foodRecord != null) {
      suggestion.foodRecord?.logMeal();
      await _connector.updateRecord(
          foodRecord: suggestion.foodRecord!, isNew: true);
    } else if (suggestion.passioFoodDataInfo != null) {
      PassioFoodItem? foodItem = await NutritionAI.instance
          .fetchFoodItemForDataInfo(suggestion.passioFoodDataInfo!);
      if (foodItem != null) {
        final foodRecord = FoodRecord.fromPassioFoodItem(foodItem);
        await _connector.updateRecord(foodRecord: foodRecord, isNew: true);
      } else {
        return;
      }
    } else {
      return;
    }
    emit(LogSuccessState(createdAt: DateTime.now().millisecondsSinceEpoch));
    add(const FetchSuggestionsEvent());
  }
}
