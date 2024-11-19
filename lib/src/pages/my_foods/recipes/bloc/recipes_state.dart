part of 'recipes_bloc.dart';

sealed class RecipesState extends Equatable {
  const RecipesState();
}

final class RecipesInitial extends RecipesState {
  @override
  List<Object> get props => [];
}
