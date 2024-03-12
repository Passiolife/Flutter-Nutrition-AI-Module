part of 'edit_food_bloc.dart';

abstract class EditFoodState extends Equatable {
  const EditFoodState();
}

class EditFoodInitial extends EditFoodState {
  const EditFoodInitial();

  @override
  List<Object> get props => [];
}

class ConversionSuccessState extends EditFoodState {
  const ConversionSuccessState(
      {required this.foodRecord, required this.sliderData});

  final FoodRecord? foodRecord;
  final SliderData sliderData;

  @override
  List<Object?> get props => throw UnimplementedError();
}

class UpdateServingQuantitySuccessState extends EditFoodState {
  const UpdateServingQuantitySuccessState({
    required this.quantity,
    required this.foodRecord,
    required this.sliderData,
  });

  final FoodRecord? foodRecord;
  final SliderData sliderData;
  final double quantity;

  @override
  List<Object?> get props => [quantity];
}

class UpdateServingUnitSuccessState extends EditFoodState {
  const UpdateServingUnitSuccessState({required this.foodRecord});

  final FoodRecord? foodRecord;

  @override
  List<Object?> get props => [foodRecord];
}

class UpdateDateSuccessState extends EditFoodState {
  const UpdateDateSuccessState({required this.dateTime});

  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}

class AddIngredientSuccessState extends EditFoodState {
  const AddIngredientSuccessState({required this.ingredientsCount});

  final int ingredientsCount;

  @override
  List<Object?> get props => [ingredientsCount];
}

class RemoveIngredientSuccessState extends EditFoodState {
  const RemoveIngredientSuccessState({required this.ingredientsCount});

  final int ingredientsCount;

  @override
  List<Object?> get props => [ingredientsCount];
}

class ReplaceIngredientSuccessState extends EditFoodState {
  const ReplaceIngredientSuccessState({required this.ingredient});

  final FoodRecordIngredient ingredient;

  @override
  List<Object?> get props => [ingredient];
}

class LogSuccessState extends EditFoodState {
  @override
  List<Object?> get props => [];
}
