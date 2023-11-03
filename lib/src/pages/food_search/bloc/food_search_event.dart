part of 'food_search_bloc.dart';

abstract class FoodSearchEvent {}

class DoFoodSearchEvent extends FoodSearchEvent {
  final String searchQuery;

  DoFoodSearchEvent({required this.searchQuery});
}
