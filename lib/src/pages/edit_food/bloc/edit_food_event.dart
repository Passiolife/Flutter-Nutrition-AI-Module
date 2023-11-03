part of 'edit_food_bloc.dart';

abstract class EditFoodEvent {}

class DoAddIngredientsEvent extends EditFoodEvent {
  final FoodRecord? data;
  final PassioIDAndName? ingredientData;

  DoAddIngredientsEvent({this.data, this.ingredientData});
}

class DoRemoveIngredientsEvent extends EditFoodEvent {
  final int index;
  final FoodRecord? data;

  DoRemoveIngredientsEvent({required this.index, this.data});
}

class DoUpdateIngredientEvent extends EditFoodEvent {
  final int atIndex;
  final FoodRecord? data;
  final PassioFoodItemData? updatedFoodItemData;

  DoUpdateIngredientEvent({required this.atIndex, this.data, this.updatedFoodItemData});
}

// Event will update the food record in DB.
class DoFoodUpdateEvent extends EditFoodEvent {
  final FoodRecord? data;
  final bool isFavorite;

  DoFoodUpdateEvent({required this.data, this.isFavorite = false});
}

// Event will insert the food record into the favorites of the database.
class DoFavouriteEvent extends EditFoodEvent {
  final FoodRecord? data;
  final DateTime dateTime;

  DoFavouriteEvent({required this.data, required this.dateTime});
}
