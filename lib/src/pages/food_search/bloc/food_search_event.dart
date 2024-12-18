part of 'food_search_bloc.dart';

abstract class FoodSearchEvent extends Equatable {
  const FoodSearchEvent();
}

class DoUpdateSearchEvent extends FoodSearchEvent {
  const DoUpdateSearchEvent({required this.searchText});
  final String searchText;

  @override
  List<Object?> get props => [searchText];
}

class DoFoodSearchEvent extends FoodSearchEvent {
  final String searchText;

  const DoFoodSearchEvent({required this.searchText});

  @override
  List<Object?> get props => [searchText];
}
