part of 'quick_food_scan_bloc.dart';

sealed class QuickFoodScanState {}

class QuickFoodScanInitial extends QuickFoodScanState {}

class QuickFoodLoadingState extends QuickFoodScanState {
  final bool isLoading;

  QuickFoodLoadingState({required this.isLoading});
}

class QuickFoodSuccessState extends QuickFoodScanState {
  final FoodRecord? foodRecord;
  final String? data;

  QuickFoodSuccessState({required this.foodRecord, required this.data});
}

class ShowFoodDetailsViewState extends QuickFoodScanState {
  final bool isVisible;

  ShowFoodDetailsViewState({required this.isVisible});
}

/// States for [DoLogEvent]
class FoodInsertSuccessState extends QuickFoodScanState {}

class FoodInsertFailureState extends QuickFoodScanState {
  final String message;

  FoodInsertFailureState({required this.message});
}

// States for DoFavouriteEvent
class FavoriteSuccessState extends QuickFoodScanState {}

class FavoriteFailureState extends QuickFoodScanState {
  final String message;

  FavoriteFailureState({required this.message});
}