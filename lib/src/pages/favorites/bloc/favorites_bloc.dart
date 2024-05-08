import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../nutrition_ai_module.dart';

part 'favorites_event.dart';
part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  /// [_connector] use to perform operations.
  final PassioConnector _connector =
      NutritionAIModule.instance.configuration.connector;

  FavoritesBloc() : super(const FavoritesInitial()) {
    on<GetAllFavoritesEvent>(_handleGetAllFavoritesEvent);
    on<DoFavoriteDeleteEvent>(_handleDoFavoriteDeleteEvent);
    on<DoLogEvent>(_handleDoLogEvent);
  }

  Future<void> _handleGetAllFavoritesEvent(
      GetAllFavoritesEvent event, Emitter<FavoritesState> emit) async {
    try {
      final result = await _connector.fetchFavorites();
      // No any error, so emit the success state.
      emit(GetAllFavouritesSuccessState(data: result));
    } catch (e) {
      // If found any error then emit the failure state.
      emit(GetAllFavouritesFailureState(message: e.toString()));
    }
  }

  FutureOr<void> _handleDoFavoriteDeleteEvent(
      DoFavoriteDeleteEvent event, Emitter<FavoritesState> emit) async {
    try {
      final foodRecord = event.data;
      if (foodRecord == null) {
        emit(const FavoriteDeleteFailureState(
            message: 'Something went wrong while parsing data.'));
        return;
      }
      await _connector.deleteFavorite(foodRecord: foodRecord);
      // No any error, so emit the success state.
      emit(FavoriteDeleteSuccessState(milliseconds: DateTime.now().millisecondsSinceEpoch));
    } catch (e) {
      // If found any error then emit the failure state.
      emit(FavoriteDeleteFailureState(message: e.toString()));
    }
  }

  Future<void> _handleDoLogEvent(
      DoLogEvent event, Emitter<FavoritesState> emit) async {
    try {
      final foodRecord = event.data;
      if (foodRecord == null) {
        emit(const FoodRecordLogFailureState(
            message: 'Something went wrong while parsing data.'));
        return;
      }
      foodRecord.logMeal();

      await _connector.updateRecord(foodRecord: foodRecord, isNew: true);
      // No any error, so emit the success state.
      emit(FoodRecordLogSuccessState(createdAt: foodRecord.getCreatedAt()));
    } catch (e) {
      // If found any error then emit the failure state.
      emit(FoodRecordLogFailureState(message: e.toString()));
    }
  }
}
