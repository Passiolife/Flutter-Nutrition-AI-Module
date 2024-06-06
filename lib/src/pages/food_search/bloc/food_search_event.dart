part of 'food_search_bloc.dart';

abstract class FoodSearchEvent extends Equatable {
  const FoodSearchEvent();
}

class DoFoodSearchEvent extends FoodSearchEvent {
  final String searchText;

  const DoFoodSearchEvent({required this.searchText});

  @override
  List<Object?> get props => [searchText];
}
