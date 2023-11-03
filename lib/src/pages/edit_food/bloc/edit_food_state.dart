part of 'edit_food_bloc.dart';

abstract class EditFoodState {}

class EditFoodInitial extends EditFoodState {}


/// States for DoAddIngredientsEvent
class AddIngredientsSuccessState extends EditFoodState {}

class AddIngredientsFailureState extends EditFoodState {}

// States for DoRemoveIngredientsEvent
class RemoveIngredientsState extends EditFoodState {}

// States for DoUpdateIngredientEvent
class UpdateIngredientsSuccessState extends EditFoodState {}


// States for DoFavouriteEvent
class FavoriteSuccessState extends EditFoodState {}

class FavoriteFailureState extends EditFoodState {
  final String message;

  FavoriteFailureState({required this.message});
}

// states for DoFoodUpdateEvent
class FoodUpdateSuccessState extends EditFoodState {}

class FoodUpdateFailureState extends EditFoodState {
  final String message;

  FoodUpdateFailureState({required this.message});
}