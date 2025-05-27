part of 'recipe_creator_bloc.dart';

sealed class RecipeCreatorState  extends Equatable {
  const RecipeCreatorState();
}

final class InitialState extends RecipeCreatorState {
  const InitialState();

  @override
  List<Object?> get props => [];
}
