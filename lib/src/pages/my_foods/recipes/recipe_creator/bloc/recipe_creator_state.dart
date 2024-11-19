part of 'recipe_creator_bloc.dart';

sealed class RecipeCreatorState extends Equatable {
  const RecipeCreatorState();
}

final class RecipeCreatorInitial extends RecipeCreatorState {
  @override
  List<Object> get props => [];
}
