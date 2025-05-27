part of 'recipes_bloc.dart';

sealed class RecipesState extends Equatable {
  const RecipesState();
}

final class InitialState extends RecipesState {
  const InitialState();

  @override
  List<Object?> get props => [];
}

final class FetchUserRecipesSuccessState extends RecipesState {
  final List<FoodRecord> recipes;

  const FetchUserRecipesSuccessState({required this.recipes});

  @override
  List<Object> get props => [recipes];
}

final class FetchUserRecipesErrorState extends RecipesState {
  const FetchUserRecipesErrorState({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}
