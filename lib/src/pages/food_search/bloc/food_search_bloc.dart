import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

part 'food_search_event.dart';

part 'food_search_state.dart';

class FoodSearchBloc extends Bloc<FoodSearchEvent, FoodSearchState> {
  String _previousSearchText = '';

  List<PassioSearchResult> _results = [];
  List<String> _alternatives = [];

  FoodSearchBloc() : super(const FoodSearchInitial()) {
    on<DoFoodSearchEvent>(_handleDoFoodSearchEvent);
    on<DoFetchSearchResultEvent>(_handleDoFetchSearchResultEvent);
  }

  FutureOr<void> _handleDoFoodSearchEvent(
      DoFoodSearchEvent event, Emitter<FoodSearchState> emit) async {
    final searchText = event.searchText;
    if (_previousSearchText == searchText) return;

    _previousSearchText = searchText;
    _results.clear();
    _alternatives.clear();

    // Here, checking the length of [searchQuery] and based on that we will do operations.
    //
    // If the [_searchQuery] is empty then do nothing.
    if (searchText.isEmpty) {
      emit(const FoodSearchInitial());
      return;
    } else if (searchText.length < 3) {
      /// If [searchQuery] length is less than 3 then set "Keep Typing" text.
      emit(const KeepTypingState());
      return;
    } else {
      _results = List.generate(
          20,
          (index) => const PassioSearchResult(
                brandName: '',
                foodName: '',
                iconID: '',
                labelId: '',
                nutritionPreview: PassioSearchNutritionPreview(
                  calories: 0,
                  servingUnit: '',
                  servingQuantity: 0,
                  servingWeight: '',
                ),
                resultId: '-1',
                scoredName: '',
                score: 0,
                type: '',
              ));
      _alternatives = List.generate(10, (index) => '-1');

      emit(SearchForFoodSuccessState(results: _results, alternatives: _alternatives));
      final searchResponse =
          await NutritionAI.instance.searchForFood(searchText);

      _results = searchResponse.results;
      _alternatives = searchResponse.alternateNames;
      emit(SearchForFoodSuccessState(results: _results, alternatives: _alternatives));
    }
  }

  FutureOr<void> _handleDoFetchSearchResultEvent(
      DoFetchSearchResultEvent event, Emitter<FoodSearchState> emit) async {
    PassioFoodItem? foodItem =
        await NutritionAI.instance.fetchSearchResult(event.result);
    if (foodItem != null) {
      emit(FetchSearchResultSuccessState(index: 0, foodItem: foodItem));
    } else {
      emit(const FetchSearchResultFailureState(message: 'Something went wrong.'));
    }
  }
}
