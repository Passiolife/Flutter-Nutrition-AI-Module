part of 'recipe_creator_bloc.dart';

sealed class RecipeCreatorEvent extends Equatable {
  const RecipeCreatorEvent();
}

final class DoConversionEvent extends RecipeCreatorEvent {
  final bool logUponCreate;
  final FoodRecord? loggedFoodRecord;
  final FoodRecord? recipeFoodRecord;

  const DoConversionEvent({
    required this.logUponCreate,
    this.loggedFoodRecord,
    this.recipeFoodRecord,
  });

  @override
  List<Object?> get props => [logUponCreate, loggedFoodRecord, recipeFoodRecord];
}