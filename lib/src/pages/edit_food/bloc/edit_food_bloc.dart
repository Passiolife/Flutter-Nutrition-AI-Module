import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../nutrition_ai_module.dart';

part 'edit_food_event.dart';

part 'edit_food_state.dart';

class EditFoodBloc extends Bloc<EditFoodEvent, EditFoodState> {
  /// [_connector] use to perform operations.
  PassioConnector get _connector =>
      NutritionAIModule.instance.configuration.connector;

  EditFoodBloc() : super(EditFoodInitial()) {
    on<DoFoodUpdateEvent>(_handleDoFoodUpdateEvent);
    on<DoFavouriteEvent>(_handleDoFavouriteEvent);
  }

  Future<void> _handleDoFoodUpdateEvent(
      DoFoodUpdateEvent event, Emitter<EditFoodState> emit) async {
    try {
      final foodRecord = event.data;
      if (foodRecord == null) {
        emit(FoodUpdateFailureState(
            message: 'Something went wrong while parsing data.'));
        return;
      }

      if (event.isFavorite) {
        await _connector.updateFavorite(foodRecord: foodRecord, isNew: false);
      } else {
        await _connector.updateRecord(foodRecord: foodRecord, isNew: false);
      }
      emit(FoodUpdateSuccessState());
    } catch (e) {
      emit(FoodUpdateFailureState(message: e.toString()));
    }
  }

  Future<void> _handleDoFavouriteEvent(
      DoFavouriteEvent event, Emitter<EditFoodState> emit) async {
    try {
      final foodRecord = event.data;
      if (foodRecord == null) {
        emit(FavoriteFailureState(
            message: 'Something went wrong while parsing data.'));
        return;
      }
      await _connector.updateFavorite(foodRecord: foodRecord, isNew: true);
      emit(FavoriteSuccessState());
    } catch (e) {
      emit(FavoriteFailureState(message: e.toString()));
    }
  }
}
