part of 'recipes_bloc.dart';

sealed class RecipesEvent extends Equatable {
  const RecipesEvent();
}

final class FetchUserRecipeEvent extends RecipesEvent {
  const FetchUserRecipeEvent();

  @override
  List<Object?> get props => [];
}

final class FetchUserRecipesSuccessEvent extends RecipesEvent {
  const FetchUserRecipesSuccessEvent({required this.data});
  final List<FoodRecord> data;

  @override
  List<Object?> get props => [data];
}

final class FetchUserRecipesErrorEvent extends RecipesEvent {
  const FetchUserRecipesErrorEvent({required this.error});
  final String error;

  @override
  List<Object?> get props => [error];
}