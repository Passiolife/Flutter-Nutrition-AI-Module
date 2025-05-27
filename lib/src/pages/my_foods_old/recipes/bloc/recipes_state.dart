part of 'recipes_bloc.dart';

sealed class RecipesState extends Equatable {
  const RecipesState();
}

final class RecipesInitial extends RecipesState {
  const RecipesInitial();

  @override
  List<Object> get props => [];
}

final class FetchUserRecipesSuccessState extends RecipesState {
  final List<FoodRecord> recipes;

  const FetchUserRecipesSuccessState({required this.recipes});

  @override
  List<Object> get props => [recipes];
}

final class LogSuccessState extends RecipesState {
  const LogSuccessState();

  @override
  List<Object?> get props => [];
}
