part of 'recipes_bloc.dart';

sealed class RecipesEvent extends Equatable {
  const RecipesEvent();
}

final class FetchUserRecipeEvent extends RecipesEvent {
  const FetchUserRecipeEvent();

  @override
  List<Object?> get props => [];
}

final class DoFoodLogEvent extends RecipesEvent {
  const DoFoodLogEvent({required this.foodRecord});

  final FoodRecord foodRecord;

  @override
  List<Object?> get props => [foodRecord];
}

final class DoUpdateUserRecipeEvent extends RecipesEvent {
  const DoUpdateUserRecipeEvent({required this.foodRecord});

  final FoodRecord foodRecord;

  @override
  List<Object?> get props => [foodRecord];
}

final class DoDeleteUserRecipeEvent extends RecipesEvent {
  const DoDeleteUserRecipeEvent({required this.foodRecord});

  final FoodRecord foodRecord;

  @override
  List<Object?> get props => [foodRecord];
}