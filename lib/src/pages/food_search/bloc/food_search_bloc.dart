import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../nutrition_ai_module.dart';
import '../../../common/domain/use_cases/food_logs/add_food_log_use_case.dart';

part 'food_search_event.dart';
part 'food_search_state.dart';

class FoodSearchBloc extends Bloc<FoodSearchEvent, FoodSearchState> {
  String _previousSearchText = '';

  List<dynamic>? searchResults;
  List<dynamic> myFoods = [];

  List<String> alternatives = [];

  /// [_connector] use to perform operations.
  final PassioConnector _connector =
      NutritionAIModule.instance.configuration.connector;

  String searchTerm = '';

  final AddFoodLogUseCase addFoodLogUseCase;

  FoodSearchBloc({required this.addFoodLogUseCase})
      : super(const FoodSearchInitial()) {
    on<DoUpdateSearchEvent>(_handleDoUpdateSearchEvent);
    on<DoFoodSearchEvent>(_handleDoFoodSearchEvent);
    on<DoFoodLogEvent>(_handleDoFoodLogEvent);
  }

  FutureOr<void> _handleDoUpdateSearchEvent(
      DoUpdateSearchEvent event, Emitter<FoodSearchState> emit) async {
    emit(UpdateSearchState(searchText: event.searchText));
  }

  FutureOr<void> _handleDoFoodSearchEvent(
      DoFoodSearchEvent event, Emitter<FoodSearchState> emit) async {
    searchTerm = event.searchText;
    if (_previousSearchText == searchTerm) return;

    _previousSearchText = searchTerm;

    // Here, checking the length of [searchQuery] and based on that we will do operations.
    //
    // If the [_searchQuery] is empty then do nothing.
    if (searchTerm.isEmpty) {
      emit(const FoodSearchInitial());
      return;
    } else if (searchTerm.length < 3) {
      /// If [searchQuery] length is less than 3 then set "Keep Typing" text.
      emit(const KeepTypingState());
      return;
    } else {
      searchResults = List.generate(20, (index) => index);
      myFoods = List.generate(20, (index) => index);
      alternatives = List.generate(10, (index) => '-1');

      emit(FoodSearchSuccessState(
        results: searchResults,
        alternatives: alternatives,
      ));

      final searchResponse =
          await NutritionAI.instance.searchForFood(searchTerm);

      myFoods = await _connector.searchUserFoodsByName(term: searchTerm);

      searchResults = searchResponse.results;
      alternatives = searchResponse.alternateNames;
      emit(FoodSearchSuccessState(
          results: searchResults, alternatives: alternatives));
    }
  }

  Future<void> _handleDoFoodLogEvent(
      DoFoodLogEvent event, Emitter<FoodSearchState> emit) async {
    final foodDataInfo = event.foodDataInfo;
    final passedFoodRecord = event.foodRecord;
    if (foodDataInfo == null && passedFoodRecord == null) {
      return;
    }

    FoodRecord foodRecord;

    if (foodDataInfo != null) {
      final foodItem =
          await NutritionAI.instance.fetchFoodItemForDataInfo(foodDataInfo);
      if (foodItem == null) {
        return;
      }
      foodRecord = FoodRecord.fromPassioFoodItem(foodItem);
    } else {
      foodRecord = passedFoodRecord!;
    }

    addFoodLogUseCase(foodRecord: foodRecord, isNew: true);

    emit(FoodLogSuccessState(DateTime.now().millisecondsSinceEpoch));
  }
}
