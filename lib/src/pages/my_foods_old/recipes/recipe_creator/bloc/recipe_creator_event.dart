part of 'recipe_creator_bloc.dart';

sealed class RecipeCreatorEvent extends Equatable {
  const RecipeCreatorEvent();
}

class DoPrefillEvent extends RecipeCreatorEvent {
  const DoPrefillEvent({required this.data});

  final RecipeCreatorNavigationData data;

  @override
  List<Object?> get props => [data];
}

class DoUpdateImageEvent extends RecipeCreatorEvent {
  const DoUpdateImageEvent({this.image});

  final Uint8List? image;

  @override
  List<Object?> get props => [image];
}

class DoUpdateRecipeNameEvent extends RecipeCreatorEvent {
  const DoUpdateRecipeNameEvent({required this.name});

  final String name;

  @override
  List<Object?> get props => [name];
}

class DoUpdateUnitEvent extends RecipeCreatorEvent {
  const DoUpdateUnitEvent({this.unit});

  final String? unit;

  @override
  List<Object?> get props => [unit];
}

class DoUpdateQuantityEvent extends RecipeCreatorEvent {
  const DoUpdateQuantityEvent(
      {required this.quantity, this.fromSlider = false});

  final double quantity;
  final bool fromSlider;

  @override
  List<Object?> get props => [quantity, fromSlider];
}

class DoConvertIngredientEvent extends RecipeCreatorEvent {
  const DoConvertIngredientEvent({
    this.foodDataInfo,
    this.foodRecord,
  });

  final PassioFoodDataInfo? foodDataInfo;
  final FoodRecord? foodRecord;

  @override
  List<Object?> get props => [foodDataInfo, foodRecord];
}

class DoUpdateIngredients extends RecipeCreatorEvent {
  const DoUpdateIngredients(
      {this.index, required this.foodRecord, this.isUpdate = false});

  final FoodRecord foodRecord;
  final int? index;
  final bool isUpdate;

  @override
  List<Object?> get props => [index, foodRecord, isUpdate];
}

class DoUpdateVisibilityAddIngredientOptionsEvent extends RecipeCreatorEvent {
  const DoUpdateVisibilityAddIngredientOptionsEvent({required this.isVisible});

  final bool isVisible;

  @override
  List<Object?> get props => [isVisible];
}

class DoDeleteIngredientEvent extends RecipeCreatorEvent {
  const DoDeleteIngredientEvent({required this.index});

  final int index;

  @override
  List<Object?> get props => [index];
}

class SaveRecipeEvent extends RecipeCreatorEvent {
  const SaveRecipeEvent();

  @override
  List<Object?> get props => [];
}
