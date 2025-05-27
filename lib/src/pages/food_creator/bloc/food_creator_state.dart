part of 'food_creator_bloc.dart';

sealed class FoodCreatorState extends Equatable {
  const FoodCreatorState();
}

final class InitialState extends FoodCreatorState {
  const InitialState({this.foodCreatorModel});

  final FoodCreatorModel? foodCreatorModel;

  @override
  List<Object?> get props => [foodCreatorModel];
}

final class UpdateFoodDetailsState extends FoodCreatorState {
  const UpdateFoodDetailsState({
    required this.name,
    required this.brand,
    required this.barcode,
  });

  final String? name;
  final String? brand;
  final String? barcode;

  @override
  List<Object?> get props => [name, brand, barcode];
}

final class UnitChangedState extends FoodCreatorState {
  const UnitChangedState({required this.unit});

  final KeyValueModel<String> unit;

  @override
  List<Object?> get props => [unit];
}

final class WeightSymbolChangedState extends FoodCreatorState {
  const WeightSymbolChangedState({required this.weightSymbol});

  final KeyValueModel<String> weightSymbol;

  @override
  List<Object?> get props => [weightSymbol];
}

final class OtherNutritionFactsSelectedState extends FoodCreatorState {
  const OtherNutritionFactsSelectedState({required this.selectedNutrient});

  final KeyValueModel<nutrition_ai.UnitMass> selectedNutrient;

  @override
  List<Object?> get props => [selectedNutrient];
}

final class OtherNutritionFactsRemovedState extends FoodCreatorState {
  const OtherNutritionFactsRemovedState({required this.selectedNutrient});

  final KeyValueModel<nutrition_ai.UnitMass> selectedNutrient;

  @override
  List<Object?> get props => [selectedNutrient];
}

final class SaveErrorState extends FoodCreatorState {
  const SaveErrorState({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

final class SaveSuccessState extends FoodCreatorState {
  const SaveSuccessState();

  @override
  List<Object?> get props => [];
}

final class SaveLoadingState extends FoodCreatorState {
  const SaveLoadingState();

  @override
  List<Object?> get props => [];
}
