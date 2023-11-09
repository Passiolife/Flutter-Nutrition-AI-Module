import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../nutrition_ai_module.dart';
import '../../../common/constant/dimens.dart';

part 'favourite_event.dart';

part 'favourite_state.dart';

class FavouriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  /// [_connector] use to perform operations.
  PassioConnector get _connector => NutritionAIModule.instance.configuration.connector;

  FavouriteBloc() : super(FavouriteInitial()) {
    on<GetAllFavoritesEvent>(_handleGetAllFavouritesEvent);
    on<DoFavoriteUpdateEvent>(_handleDoFavoriteUpdateEvent);
    on<DoFavoriteDeleteEvent>(_handleDoFavoriteDeleteEvent);
    on<DoLogEvent>(_handleDoLogEvent);
  }

  FutureOr<void> _handleGetAllFavouritesEvent(GetAllFavoritesEvent event, Emitter<FavoriteState> emit) async {
    try {
      final result = await _connector.fetchFavorites();
      // No any error, so emit the success state.
      emit(GetAllFavouritesSuccessState(data: result));
    } catch (e) {
      // If found any error then emit the failure state.
      emit(GetAllFavouritesFailureState(message: e.toString()));
    }
  }

  FutureOr<void> _handleDoFavoriteUpdateEvent(DoFavoriteUpdateEvent event, Emitter<FavoriteState> emit) async {
    try {
      final foodRecord = event.data;
      if (foodRecord == null) {
        emit(FavoriteUpdateFailureState(message: 'Something went wrong while parsing data.'));
        return;
      }
      await _connector.updateFavorite(foodRecord: foodRecord, isNew: false);
      // No any error, so emit the success state.
      emit(FavoriteUpdateSuccessState());
    } catch (e) {
      // If found any error then emit the failure state.
      emit(FavoriteUpdateFailureState(message: e.toString()));
    }
  }

  FutureOr<void> _handleDoFavoriteDeleteEvent(DoFavoriteDeleteEvent event, Emitter<FavoriteState> emit) async {
    try {
      final foodRecord = event.data;
      if (foodRecord == null) {
        emit(FavoriteDeleteFailureState(message: 'Something went wrong while parsing data.'));
        return;
      }
      await _connector.deleteFavorite(foodRecord: foodRecord);
      // No any error, so emit the success state.
      emit(FavoriteDeleteSuccessState());
    } catch (e) {
      // If found any error then emit the failure state.
      emit(FavoriteDeleteFailureState(message: e.toString()));
    }
  }

  FutureOr<void> _handleDoLogEvent(DoLogEvent event, Emitter<FavoriteState> emit) async {
    try {
      emit(FoodRecordLogLoadingState(index: event.index));
      final foodRecord = event.data;
      if (foodRecord == null) {
        emit(FoodRecordLogFailureState(message: 'Something went wrong while parsing data.'));
        return;
      }
      final selectedDateTime = DateTime.now();
      foodRecord.createdAt = selectedDateTime.millisecondsSinceEpoch.toDouble();
      foodRecord.mealLabel = MealLabel.mealLabelBy(selectedDateTime);

      await _connector.updateRecord(foodRecord: foodRecord, isNew: true);
      // Waiting for some time to finish the animation.
      await Future.delayed(const Duration(milliseconds: Dimens.duration500));
      // No any error, so emit the success state.
      emit(FoodRecordLogSuccessState());
    } catch (e) {
      // If found any error then emit the failure state.
      emit(FoodRecordLogFailureState(message: e.toString()));
    }
  }
}
