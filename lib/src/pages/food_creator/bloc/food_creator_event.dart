part of 'food_creator_bloc.dart';

sealed class FoodCreatorEvent extends Equatable {
  const FoodCreatorEvent();
}

final class UpdateImageEvent extends FoodCreatorEvent {
  final Uint8List? image;

  const UpdateImageEvent({required this.image});

  @override
  List<Object?> get props => [image];
}

final class UpdateNameEvent extends FoodCreatorEvent {
  final String name;

  const UpdateNameEvent({required this.name});

  @override
  List<Object> get props => [name];
}

final class UpdateBrandEvent extends FoodCreatorEvent {
  final String brand;

  const UpdateBrandEvent({required this.brand});

  @override
  List<Object> get props => [brand];
}

final class UpdateServingSizeEvent extends FoodCreatorEvent {
  final String servingSize;

  const UpdateServingSizeEvent({required this.servingSize});

  @override
  List<Object> get props => [servingSize];
}

final class UpdateUnitEvent extends FoodCreatorEvent {
  final KeyValueModel<String>? unit;

  const UpdateUnitEvent({required this.unit});

  @override
  List<Object?> get props => [unit];
}

final class UpdateWeightEvent extends FoodCreatorEvent {
  final String weight;

  const UpdateWeightEvent({required this.weight});

  @override
  List<Object> get props => [weight];
}

final class UpdateWeightSymbolEvent extends FoodCreatorEvent {
  final KeyValueModel<String>? weightSymbol;

  const UpdateWeightSymbolEvent({required this.weightSymbol});

  @override
  List<Object?> get props => [weightSymbol];
}

final class UpdateCaloriesEvent extends FoodCreatorEvent {
  final String calories;

  const UpdateCaloriesEvent({required this.calories});

  @override
  List<Object> get props => [calories];
}

final class UpdateFatEvent extends FoodCreatorEvent {
  final String fat;

  const UpdateFatEvent({required this.fat});

  @override
  List<Object> get props => [fat];
}

final class UpdateCarbsEvent extends FoodCreatorEvent {
  final String carbs;

  const UpdateCarbsEvent({required this.carbs});

  @override
  List<Object> get props => [carbs];
}

final class UpdateProteinEvent extends FoodCreatorEvent {
  final String protein;

  const UpdateProteinEvent({required this.protein});

  @override
  List<Object> get props => [protein];
}

final class SelectOtherNutritionFactsEvent extends FoodCreatorEvent {
  final KeyValueModel<nutrition_ai.UnitMass> selectedNutrient;

  const SelectOtherNutritionFactsEvent({required this.selectedNutrient});

  @override
  List<Object> get props => [selectedNutrient];
}

final class UpdateOtherNutritionFactsEvent extends FoodCreatorEvent {
  final KeyValueModel<nutrition_ai.UnitMass> selectedNutrient;

  const UpdateOtherNutritionFactsEvent({required this.selectedNutrient});

  @override
  List<Object> get props => [selectedNutrient];
}

final class RemoveOtherNutritionFactsEvent extends FoodCreatorEvent {
  final KeyValueModel<nutrition_ai.UnitMass> selectedNutrient;

  const RemoveOtherNutritionFactsEvent({required this.selectedNutrient});

  @override
  List<Object> get props => [selectedNutrient];
}

final class SubmitUserCreatedFoodEvent extends FoodCreatorEvent {
  const SubmitUserCreatedFoodEvent();

  @override
  List<Object> get props => [];
}

final class SaveSuccessEvent extends FoodCreatorEvent {
  const SaveSuccessEvent();

  @override
  List<Object> get props => [];
}

final class SaveErrorEvent extends FoodCreatorEvent {
  final String message;

  const SaveErrorEvent({required this.message});

  @override
  List<Object> get props => [message];
}

final class UpdateBarcodeEvent extends FoodCreatorEvent {
  final String barcode;

  const UpdateBarcodeEvent({required this.barcode});

  @override
  List<Object> get props => [barcode];
}

final class DoConversionEvent extends FoodCreatorEvent {
  final int? index;
  final FoodRecord? foodRecord;

  const DoConversionEvent({this.index, this.foodRecord});

  @override
  List<Object?> get props => [index, foodRecord];
}

final class UpdateFoodDetailsEvent extends FoodCreatorEvent {
  const UpdateFoodDetailsEvent();

  @override
  List<Object?> get props => [];
}