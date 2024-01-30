import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

part 'food_search_event.dart';
part 'food_search_state.dart';

class FoodSearchBloc extends Bloc<FoodSearchEvent, FoodSearchState> {

  FoodSearchBloc() : super(FoodSearchInitial()) {
    on<DoFoodSearchEvent>(_doFoodSearchEvent);
  }

  Future<void> _doFoodSearchEvent(DoFoodSearchEvent event, Emitter<FoodSearchState> emit) async {
    /// Here, checking the length of [searchQuery] and based on that we will do operations.
    ///
    /// If the [_searchQuery] is empty then do nothing.
    if (event.searchQuery.isEmpty) {
      emit(FoodSearchInitial());
      return;
    } else if (event.searchQuery.length < 3) {
      /// If [searchQuery] length is less than 3 then set "Keep Typing" text.
      emit(FoodSearchTypingState());
      return;
    } else {
      /// Here, we emitting the searching, So, user will get the Searching view on the screen.
      emit(FoodSearchLoadingState());
    }

    final data = await NutritionAI.instance.searchForFood(event.searchQuery);

    /// Here we are checking if filter data is empty or not.
    if (data.isNotEmpty) {
      /// Here, we are checking if data is not empty then pass that data to the state.
      /// And filtered data will be visible to the user.
      emit(FoodSearchSuccessState(data: data));
    } else {
      /// There is empty data in the filter. So, we will display no data screen to the user.
      emit(FoodSearchFailureState(searchQuery: event.searchQuery));
    }
  }
}
