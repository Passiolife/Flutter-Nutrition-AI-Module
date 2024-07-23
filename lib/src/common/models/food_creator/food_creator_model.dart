import 'dart:typed_data';

import '../../../../../../nutrition_ai_module.dart';
import '../../util/flutter_image_compress_util.dart';

class Nutrient {
  final String value;
  final String label;
  final UnitMassType type;

  const Nutrient({
    required this.value,
    required this.label,
    required this.type,
  });

  Nutrient copyWith(
      {String? value, String? label, UnitMassType? type, Unit? unit}) {
    return Nutrient(
      value: value ?? this.value,
      label: label ?? this.label,
      type: type ?? this.type,
    );
  }

  UnitMass? toUnitMass() {
    final parsedValue = double.tryParse(value);
    if (parsedValue != null) {
      return UnitMass(parsedValue, type);
    }
    return null;
  }
}


class FoodCreatorModel {

  Uint8List? image;
  Uint8List? resizedImage;
  String? name;
  String? brand;
  String? barcode;

  double? servingQuantity;
  String? servingUnit;
  double? weightValue;
  String? weightSymbol;
  Unit? calories;
  Unit? fat;
  Unit? carbs;
  Unit? protein;

  Nutrient? satFat;
  Nutrient? transFat;
  Nutrient? cholesterol;
  Nutrient? sodium;
  Nutrient? dietaryFiber;
  Nutrient? totalSugars;
  Nutrient? addedSugars;
  Nutrient? vitaminD;
  Nutrient? calcium;
  Nutrient? potassium;

  bool get isSaveEnabled {
    final bool isNameNotEmpty = name?.isNotEmpty ?? false;
    final bool isServingQuantityNotNull = servingQuantity != null && servingQuantity != 0;
    final bool isServingUnitNotNull = servingUnit?.isNotEmpty ?? false;

    const gram = 'gram';
    const ml = 'ml';

    final bool isWeightValid = (servingUnit != gram && servingUnit != ml)
        ? weightValue != null && weightSymbol != null
        : true;

    final caloriesValid = calories != null;
    final fatValid = fat != null;
    final carbsValid = carbs != null;
    final proteinValid = protein != null;

    return isNameNotEmpty &&
        isServingQuantityNotNull &&
        isServingUnitNotNull &&
        isWeightValid &&
        caloriesValid &&
        fatValid &&
        carbsValid &&
        proteinValid;
  }

  Future<void> updateImage(Uint8List? newImage) async {
    if (image != newImage) {
      image = newImage;
      if (image != null) {
        resizedImage = await FlutterImageCompressUtil.compressWithList(
          image!,
          minWidth: 200,
          minHeight: 200,
        );
      }
    }
  }

  void updateDetails(String? newName, String? newBrand) {
    name = newName;
    brand = newBrand;
  }

  void updateBarcode(String? newBarcode) {
    barcode = newBarcode;
  }

  void updateRequiredNutritionFacts(
      double? newServingQuantity,
      String? newServingUnit,
      double? newWeightValue,
      String? newWeightSymbol,
      Unit? newCalories,
      Unit? newFat,
      Unit? newCarbs,
      Unit? newProtein) {
    servingQuantity = newServingQuantity;
    servingUnit = newServingUnit;
    weightValue = newWeightValue;
    weightSymbol = newWeightSymbol;
    calories = newCalories;
    fat = newFat;
    carbs = newCarbs;
    protein = newProtein;
  }

  void updateOtherNutritionFacts(
      Nutrient? newSatFat,
      Nutrient? newTransFat,
      Nutrient? newCholesterol,
      Nutrient? newSodium,
      Nutrient? newDietaryFiber,
      Nutrient? newTotalSugars,
      Nutrient? newAddedSugars,
      Nutrient? newVitaminD,
      Nutrient? newCalcium,
      Nutrient? newPotassium) {
    satFat = newSatFat;
    transFat = newTransFat;
    cholesterol = newCholesterol;
    sodium = newSodium;
    dietaryFiber = newDietaryFiber;
    totalSugars = newTotalSugars;
    addedSugars = newAddedSugars;
    vitaminD = newVitaminD;
    calcium = newCalcium;
    potassium = newPotassium;
  }
}