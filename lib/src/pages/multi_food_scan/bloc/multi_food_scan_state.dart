part of 'multi_food_scan_bloc.dart';

sealed class MultiFoodScanState {}

class QuickFoodScanInitial extends MultiFoodScanState {}

class QuickFoodLoadingState extends MultiFoodScanState {
  final bool isLoading;

  QuickFoodLoadingState({required this.isLoading});
}

class QuickFoodSuccessState extends MultiFoodScanState {
  final FoodRecord? foodRecord;

  QuickFoodSuccessState({required this.foodRecord});
}

class ShowFoodDetailsViewState extends MultiFoodScanState {
  final bool isVisible;
  final int index;

  ShowFoodDetailsViewState({required this.isVisible, required this.index});
}

/// States for [DoAddAllEvent]
class FoodInsertSuccessState extends MultiFoodScanState {}

class FoodInsertFailureState extends MultiFoodScanState {}

/// States for [DoNewRecipeEvent]
class NewRecipeSuccessState extends MultiFoodScanState {}

class NewRecipeFailureState extends MultiFoodScanState {
  final String message;

  NewRecipeFailureState({required this.message});
}
