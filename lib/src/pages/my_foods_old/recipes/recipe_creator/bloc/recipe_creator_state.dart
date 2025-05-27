part of 'recipe_creator_bloc.dart';

sealed class RecipeCreatorState extends Equatable {
  const RecipeCreatorState();
}

final class RecipeCreatorInitial extends RecipeCreatorState {
  const RecipeCreatorInitial();

  @override
  List<Object> get props => [];
}

sealed class RecipeCreatorBuilderState extends RecipeCreatorState {
  const RecipeCreatorBuilderState();
}

final class UpdateImageBuilderState extends RecipeCreatorBuilderState {
  const UpdateImageBuilderState({this.image});

  final Uint8List? image;

  @override
  List<Object?> get props => [image];
}

final class UpdateRecipeNameBuilderState extends RecipeCreatorBuilderState {
  const UpdateRecipeNameBuilderState({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}

final class UpdateQuantityBuilderState extends RecipeCreatorBuilderState {
  const UpdateQuantityBuilderState({required this.quantity});

  final double quantity;

  @override
  List<Object?> get props => [quantity];
}

final class UpdateUnitBuilderState extends RecipeCreatorBuilderState {
  const UpdateUnitBuilderState({required this.unit});

  final String? unit;

  @override
  List<Object?> get props => [unit];
}

final class ShowAddIngredientOptionsBuilderState
    extends RecipeCreatorBuilderState {
  const ShowAddIngredientOptionsBuilderState({required this.isVisible});

  final bool isVisible;

  @override
  List<Object?> get props => [isVisible];
}

final class UpdateIngredientsBuilderState extends RecipeCreatorBuilderState {
  const UpdateIngredientsBuilderState({required this.foodRecord});

  final FoodRecord foodRecord;

  @override
  List<Object?> get props => [foodRecord];
}

final class DeleteIngredientBuilderState extends RecipeCreatorBuilderState {
  const DeleteIngredientBuilderState({required this.timestamp});

  final int timestamp;

  @override
  List<Object?> get props => [timestamp];
}

final class SaveRecipeSuccessState extends RecipeCreatorBuilderState {
  const SaveRecipeSuccessState({
    required this.logUponCreate,
    required this.userRecipeRecord,
  });

  final bool logUponCreate;
  final FoodRecord? userRecipeRecord;

  @override
  List<Object?> get props => [logUponCreate, userRecipeRecord];
}

final class PrefillSuccessState extends RecipeCreatorBuilderState {
  const PrefillSuccessState({required this.viewModel});

  final RecipeCreatorViewModel viewModel;

  @override
  List<Object?> get props => [viewModel];
}
