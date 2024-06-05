part of 'edit_food_bloc.dart';

abstract class EditFoodEvent extends Equatable {
  const EditFoodEvent();
}

class DoConversionEvent extends EditFoodEvent {
  const DoConversionEvent({
    this.foodItem,
    this.foodRecord,
    this.foodRecordIngredient,
    this.detectedCandidate,
    this.foodDataInfo,
    this.mealLabel,
    this.shouldUpdateServingUnit = false,
  });

  final PassioFoodItem? foodItem;
  final FoodRecord? foodRecord;
  final FoodRecordIngredient? foodRecordIngredient;
  final DetectedCandidate? detectedCandidate;
  final PassioFoodDataInfo? foodDataInfo;
  final MealLabel? mealLabel;
  final bool shouldUpdateServingUnit;

  @override
  List<Object?> get props => [
        foodItem,
        foodRecord,
        foodRecordIngredient,
        detectedCandidate,
        foodDataInfo,
        mealLabel,
        shouldUpdateServingUnit
      ];
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
    required this.searchResult,
  });

  final PassioFoodDataInfo searchResult;

  @override
  List<Object?> get props => [searchResult];
}

class DoLogEvent extends EditFoodEvent {
  const DoLogEvent({required this.isUpdate});

  final bool isUpdate;

  @override
  List<Object?> get props => [isUpdate];
}

class DoDeleteLogEvent extends EditFoodEvent {
  const DoDeleteLogEvent();

  @override
  List<Object?> get props => [];
}

class DoRemoveIngredientEvent extends EditFoodEvent {
  const DoRemoveIngredientEvent({required this.index});

  final int index;

  @override
  List<Object?> get props => [index];
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

class DoFavoriteChangeEvent extends EditFoodEvent {
  const DoFavoriteChangeEvent({this.name});

  final String? name;

  @override
  List<Object?> get props => [name];
}
