part of 'food_search_bloc.dart';

abstract class FoodSearchState extends Equatable {
  const FoodSearchState();
}

class FoodSearchInitial extends FoodSearchState {
  const FoodSearchInitial();

  @override
  List<Object> get props => [];
}

class KeepTypingState extends FoodSearchState {
  const KeepTypingState();

  @override
  List<Object?> get props => [];
}

class SearchingState extends FoodSearchState {
  const SearchingState();

  @override
  List<Object?> get props => [];
}

class UpdateSearchState extends FoodSearchState {
  const UpdateSearchState({required this.searchText});

  final String searchText;

  @override
  List<Object?> get props => [searchText];
}

class SearchForFoodSuccessState extends FoodSearchState {
  const SearchForFoodSuccessState({
    required this.results,
    required this.alternatives,
  });

  final List<dynamic>? results;
  final List<String> alternatives;

  @override
  List<Object?> get props => [results, alternatives];
}
