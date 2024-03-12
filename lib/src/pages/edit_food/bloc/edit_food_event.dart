part of 'edit_food_bloc.dart';

abstract class EditFoodEvent extends Equatable {
  const EditFoodEvent();
}

class DoConversionEvent extends EditFoodEvent {
  const DoConversionEvent({this.foodItem, this.foodRecord, this.foodRecordIngredient});

  final PassioFoodItem? foodItem;
  final FoodRecord? foodRecord;
  final FoodRecordIngredient? foodRecordIngredient;

  @override
  List<Object?> get props => [foodItem, foodRecord, foodRecordIngredient];
}

class DoUpdateServingQuantityEvent extends EditFoodEvent {
  const DoUpdateServingQuantityEvent({
    required this.quantity,
    required this.resetSlider,
  });

  final double quantity;
  final bool resetSlider;

  @override
  List<Object?> get props => [quantity, resetSlider];
}

class DoUpdateServingUnitEvent extends EditFoodEvent {
  const DoUpdateServingUnitEvent({required this.unit});

  final String unit;

  @override
  List<Object?> get props => [unit];
}

class DoUpdateMealLabelEvent extends EditFoodEvent {
  const DoUpdateMealLabelEvent({required this.mealLabel});

  final MealLabel mealLabel;

  @override
  List<Object?> get props => [mealLabel];
}

class DoUpdateDateEvent extends EditFoodEvent {
  const DoUpdateDateEvent({required this.dateTime});

  final DateTime dateTime;

  @override
  List<Object?> get props => [dateTime];
}

class DoAddIngredientEvent extends EditFoodEvent {
  const DoAddIngredientEvent({
    required this.foodItem,
  });

  final PassioFoodItem foodItem;

  @override
  List<Object?> get props => [foodItem];
}

class DoLogEvent extends EditFoodEvent {
  const DoLogEvent();

  @override
  List<Object?> get props => [];
}

class DoRemoveIngredientEvent extends EditFoodEvent {
  const DoRemoveIngredientEvent({required this.ingredient});

  final FoodRecordIngredient ingredient;

  @override
  List<Object?> get props => [ingredient];
}

class DoReplaceIngredientEvent extends EditFoodEvent {
  const DoReplaceIngredientEvent({
    required this.index,
    required this.ingredient,
  });

  final int index;
  final FoodRecord ingredient;

  @override
  List<Object?> get props => [index, ingredient];
}
