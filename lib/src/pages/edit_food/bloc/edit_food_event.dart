part of 'edit_food_bloc.dart';

abstract class EditFoodEvent {}


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
