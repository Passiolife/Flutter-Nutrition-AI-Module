part of 'food_creator_bloc.dart';

sealed class FoodCreatorEvent extends Equatable {
  const FoodCreatorEvent();
}

final class DoUpdateFoodDetailsEvent extends FoodCreatorEvent {
  const DoUpdateFoodDetailsEvent({
    this.image,
    this.name,
    this.brand,
  });

  final Uint8List? image;
  final String? name;
  final String? brand;

  @override
  List<Object?> get props => [image, name, brand];
}

final class DoUpdateBarcodeEvent extends FoodCreatorEvent {
  const DoUpdateBarcodeEvent({this.barcode});

  final String? barcode;

  @override
  List<Object?> get props => [barcode];
}

final class DoUpdateRequiredNutritionFactsEvent extends FoodCreatorEvent {
  const DoUpdateRequiredNutritionFactsEvent({
    this.servingQuantity,
    this.servingUnit,
    this.weightValue,
    this.weightSymbol,
    this.calories,
    this.fat,
    this.carbs,
    this.protein,
  });

  final double? servingQuantity;
  final String? servingUnit;
  final double? weightValue;
  final String? weightSymbol;
  final Unit? calories;
  final Unit? fat;
  final Unit? carbs;
  final Unit? protein;

  @override
  List<Object?> get props => [
        servingQuantity,
        servingUnit,
        weightValue,
        weightSymbol,
        calories,
        fat,
        carbs,
        protein,
      ];
}

final class DoUpdateOtherNutritionFactsEvent extends FoodCreatorEvent {
  const DoUpdateOtherNutritionFactsEvent({
    this.satFat,
    this.transFat,
    this.cholesterol,
    this.sodium,
    this.dietaryFiber,
    this.totalSugars,
    this.addedSugars,
    this.vitaminD,
    this.calcium,
    this.potassium,
  });

  final Nutrient? satFat;
  final Nutrient? transFat;
  final Nutrient? cholesterol;
  final Nutrient? sodium;
  final Nutrient? dietaryFiber;
  final Nutrient? totalSugars;
  final Nutrient? addedSugars;
  final Nutrient? vitaminD;
  final Nutrient? calcium;
  final Nutrient? potassium;

  @override
  List<Object?> get props => [
        satFat,
        transFat,
        cholesterol,
        sodium,
        dietaryFiber,
        totalSugars,
        addedSugars,
        vitaminD,
        calcium,
        potassium
      ];
}

final class DoSaveEvent extends FoodCreatorEvent {
  const DoSaveEvent({this.oldFoodRecord, required this.isUpdate});

  final FoodRecord? oldFoodRecord;
  final bool isUpdate;

  @override
  List<Object?> get props => [oldFoodRecord, isUpdate];
}
