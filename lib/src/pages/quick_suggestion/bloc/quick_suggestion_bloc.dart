import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';
import 'package:nutrition_ai/nutrition_ai.dart' as nutrition_ai;

import '../../../common/domain/use_cases/nutrition_ai/fetch_food_item_for_data_info_use_case.dart';
import '../../../common/domain/use_cases/nutrition_ai/fetch_suggestions_use_case.dart';
import '../../../common/domain/use_cases/passio_connector/fetch_day_records_use_case.dart';
import '../../../common/domain/use_cases/passio_connector/fetch_records_use_case.dart';
import '../../../common/domain/use_cases/passio_connector/update_record_use_case.dart';
import '../../../common/models/day_log/day_log.dart';
import '../../../common/models/food_record/food_record.dart';
import '../../../common/models/food_record/meal_label.dart';
import '../../../common/models/quick_suggestion/quick_suggestion.dart';
import '../../../common/util/command.dart';
import '../../../common/util/iterable_extension.dart';
import '../../../common/util/result.dart';

part 'quick_suggestion_event.dart';
part 'quick_suggestion_state.dart';

class QuickSuggestionBloc
    extends Bloc<QuickSuggestionEvent, QuickSuggestionState> {
  QuickSuggestionBloc({
    required FetchRecordsUseCase fetchRecordsUseCase,
    required FetchSuggestionsUseCase fetchSuggestionsUseCase,
    required FetchDayRecordsUseCase fetchDayRecordsUseCase,
    required UpdateRecordUseCase updateRecordUseCase,
    required FetchFoodItemForDataInfoUseCase fetchFoodItemForDataInfoUseCase,
  })  : _fetchRecordsUseCase = fetchRecordsUseCase,
        _fetchSuggestionsUseCase = fetchSuggestionsUseCase,
        _fetchDayRecordsUseCase = fetchDayRecordsUseCase,
        _updateRecordUseCase = updateRecordUseCase,
        _fetchFoodItemForDataInfoUseCase = fetchFoodItemForDataInfoUseCase,
        super(const InitialState()) {
    on<FetchSuggestionsEvent>(_fetchSuggestionsEvent);
    on<DoLogEvent>(_handleDoLogEvent);

    addLog = Command1<void, QuickSuggestion>(_doLog);
    add(const FetchSuggestionsEvent());
  }

  final FetchRecordsUseCase _fetchRecordsUseCase;
  final FetchSuggestionsUseCase _fetchSuggestionsUseCase;
  final FetchDayRecordsUseCase _fetchDayRecordsUseCase;
  final UpdateRecordUseCase _updateRecordUseCase;
  final FetchFoodItemForDataInfoUseCase _fetchFoodItemForDataInfoUseCase;

  List<QuickSuggestion> _suggestions = [];

  List<QuickSuggestion> get suggestions => _suggestions;

  late final Command1 addLog;

  Future<void> _fetchSuggestionsEvent(
      FetchSuggestionsEvent event, Emitter<QuickSuggestionState> emit) async {
    final mealLabel = MealLabel.dateToMealLabel(DateTime.now());

    // Get current date and calculate start date 30 days ago
    final endDate = DateTime.now();
    final startDate = endDate.subtract(const Duration(days: 30));

    // Fetch logged food records within the last 30 days and remove duplicates
    final Result<List<FoodRecord>> fetchRecordsResult =
        await _fetchRecordsUseCase(
            FetchRecordsParams(fromDate: startDate, endDate: endDate));
    List<FoodRecord> loggedFoodRecords = [];

    switch (fetchRecordsResult) {
      case Success<List<FoodRecord>>():
        loggedFoodRecords = fetchRecordsResult.value;
        break;
      case Error<List<FoodRecord>>():
        emit(FetchSuggestionsErrorState(
            errorMessage: fetchRecordsResult.error.toString()));
        return;
    }

    final foodRecords =
        QuickSuggestion.fromFoodRecords(mealLabel, loggedFoodRecords);

    // Get meal label and determine meal time
    final mealTime = nutrition_ai.PassioMealTime.values.firstWhere((element) =>
        element.name.toLowerCase() == mealLabel.value.toLowerCase());

    // Fetch nutrition suggestions based on meal time
    final mealTimeSuggestionsResult = await _fetchSuggestionsUseCase
        .call(FetchSuggestionsParams(mealTime: mealTime));

    List<nutrition_ai.PassioFoodDataInfo> mealTimeSuggestions = [];

    switch (mealTimeSuggestionsResult) {
      case Success<List<nutrition_ai.PassioFoodDataInfo>>():
        mealTimeSuggestions = mealTimeSuggestionsResult.value;
        break;
      case Error<List<nutrition_ai.PassioFoodDataInfo>>():
        emit(FetchSuggestionsErrorState(
            errorMessage: mealTimeSuggestionsResult.error.toString()));
        return;
    }

    final List<QuickSuggestion> suggestionRecords =
        QuickSuggestion.fromPassioFoodDataInfo(mealTimeSuggestions);
    foodRecords.addAll(suggestionRecords);

    final List<QuickSuggestion> uniqueRecords = foodRecords
        .distinct(
          by: (record) =>
              record.foodRecord?.name.toLowerCase() ??
              record.passioFoodDataInfo?.foodName.toLowerCase(),
        )
        .toList();

    final Result<List<FoodRecord>> fetchDayRecordsResult =
        await _fetchDayRecordsUseCase
            .call(FetchDayRecordsParams(dateTime: endDate));
    List<FoodRecord> dayRecords = [];

    switch (fetchDayRecordsResult) {
      case Success<List<FoodRecord>>():
        dayRecords = fetchDayRecordsResult.value;
        break;
      case Error<List<FoodRecord>>():
        emit(FetchSuggestionsErrorState(
            errorMessage: fetchDayRecordsResult.error.toString()));
        return;
    }

    final DayLog dayLog = DayLog(date: endDate, records: dayRecords);
    final List<String> foodNamesInData = dayLog
        .getFoodRecordByMeal(mealLabel)
        .map((e) => e.name.toLowerCase())
        .toList();

    uniqueRecords.removeWhere((record) {
      final name = record.foodRecord?.name.toLowerCase() ??
          record.passioFoodDataInfo?.foodName.toLowerCase();
      return foodNamesInData.contains(name);
    });

    // Take the first 30 suggestions
    _suggestions = uniqueRecords.take(30).toList();

    // Emit success state with data
    emit(FetchSuggestionsSuccessState(data: _suggestions));
  }

  Future<void> _handleDoLogEvent(
      DoLogEvent event, Emitter<QuickSuggestionState> emit) async {
    await addLog.execute(event.suggestion);
    add(const FetchSuggestionsEvent());
  }

  Future<Result<void>> _doLog(QuickSuggestion suggestion) async {
    Result<void> result;
    if (suggestion.foodRecord != null) {
      suggestion.foodRecord?.logMeal();
      result = await _updateRecordUseCase.call(
          UpdateRecordParams(foodRecord: suggestion.foodRecord!, isNew: true));
    } else if (suggestion.passioFoodDataInfo != null) {
      final Result<nutrition_ai.PassioFoodItem?> foodItemResult =
          await _fetchFoodItemForDataInfoUseCase.call(
        FetchFoodItemForDataInfoParams(
          foodDataInfo: suggestion.passioFoodDataInfo!,
        ),
      );
      nutrition_ai.PassioFoodItem? foodItem;
      switch (foodItemResult) {
        case Success<nutrition_ai.PassioFoodItem?>():
          foodItem = foodItemResult.value;
          break;
        case Error<nutrition_ai.PassioFoodItem?>():
          return Result.error(foodItemResult.error);
      }
      if (foodItem != null) {
        final foodRecord = FoodRecord.fromPassioFoodItem(foodItem);
        result = await _updateRecordUseCase
            .call(UpdateRecordParams(foodRecord: foodRecord, isNew: true));
      } else {
        result =
            Result.error(Exception('Something is wrong with Quick Suggestion'));
      }
    } else {
      result =
          Result.error(Exception('Something is wrong with Quick Suggestion'));
    }

    return result;
  }
}
