import 'package:nutrition_ai/nutrition_ai.dart';

import '../food_record/food_record.dart';

/// Represents a micro-nutrient with its name, value, recommended value, and unit symbol.
class MicroNutrient {
  /// The name of the micro-nutrient.
  final String name;

  /// The value of the micro-nutrient.
  final double value;

  /// The recommended value of the micro-nutrient.
  final double recommendedValue;

  /// The unit symbol of the micro-nutrient.
  final String unitSymbol;

  /// Constructs a MicroNutrient instance with the provided details.
  ///
  /// [name]: The name of the micro-nutrient.
  /// [value]: The value of the micro-nutrient.
  /// [recommendedValue]: The recommended value of the micro-nutrient.
  /// [unitSymbol]: The unit symbol of the micro-nutrient.
  const MicroNutrient({
    required this.name,
    required this.value,
    required this.recommendedValue,
    required this.unitSymbol,
  });

  /// Generates a list of MicroNutrient objects from a list of FoodRecord objects.
  ///
  /// [foodRecord]: The FoodRecord object to extract micro-nutrients from.
  ///
  /// Returns a list of MicroNutrient objects.
  static List<MicroNutrient> nutrientsFromFoodRecord(FoodRecord? foodRecord) {
    return nutrientsFromFoodRecords([foodRecord]);
  }

  /// Generates a list of MicroNutrient objects from a list of FoodRecord objects.
  ///
  /// [foodRecords]: The list of FoodRecord objects to extract micro-nutrients from.
  ///
  /// Returns a list of MicroNutrient objects.
  static List<MicroNutrient> nutrientsFromFoodRecords(
      List<FoodRecord?>? foodRecords) {
    if (foodRecords == null) return [];
    return [
      MicroNutrient(
        name: 'Saturated Fat',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalSatFat ?? 0)),
        recommendedValue: 20,
        unitSymbol:
            foodRecords.firstOrNull?.nutrientsSelectedSize().satFat?.symbol ??
                UnitMassType.grams.symbol,
      ),
      MicroNutrient(
        name: 'Trans Fat',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalTransFat ?? 0)),
        recommendedValue: 0,
        unitSymbol:
            foodRecords.firstOrNull?.nutrientsSelectedSize().transFat?.symbol ??
                UnitMassType.grams.symbol,
      ),
      MicroNutrient(
        name: 'Cholesterol',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalCholesterol ?? 0)),
        recommendedValue: 300,
        unitSymbol: foodRecords.firstOrNull
                ?.nutrientsSelectedSize()
                .cholesterol
                ?.symbol ??
            UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Sodium',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalSodium ?? 0)),
        recommendedValue: 2300,
        unitSymbol:
            foodRecords.firstOrNull?.nutrientsSelectedSize().sodium?.symbol ??
                UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Dietary Fiber',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalFibers ?? 0)),
        recommendedValue: 28,
        unitSymbol:
            foodRecords.firstOrNull?.nutrientsSelectedSize().fibers?.symbol ??
                UnitMassType.grams.symbol,
      ),
      MicroNutrient(
        name: 'Total Sugar',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalSugars ?? 0)),
        recommendedValue: 50,
        unitSymbol:
            foodRecords.firstOrNull?.nutrientsSelectedSize().sugars?.symbol ??
                UnitMassType.grams.symbol,
      ),

      /// Need to update recommended value and default symbol.
      MicroNutrient(
        name: 'Added Sugar',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalSugarsAdded ?? 0)),
        recommendedValue: 0,
        unitSymbol: foodRecords.firstOrNull
                ?.nutrientsSelectedSize()
                .sugarsAdded
                ?.symbol ??
            UnitMassType.grams.symbol,
      ),

      ///

      MicroNutrient(
        name: 'Vitamin D',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalVitaminD ?? 0)),
        recommendedValue: 20,
        unitSymbol:
            foodRecords.firstOrNull?.nutrientsSelectedSize().vitaminD?.symbol ??
                UnitMassType.micrograms.symbol,
      ),
      MicroNutrient(
        name: 'Calcium',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalCalcium ?? 0)),
        recommendedValue: 1000,
        unitSymbol:
            foodRecords.firstOrNull?.nutrientsSelectedSize().calcium?.symbol ??
                UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Iron',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalIron ?? 0)),
        recommendedValue: 18,
        unitSymbol:
            foodRecords.firstOrNull?.nutrientsSelectedSize().iron?.symbol ??
                UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Potassium',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalPotassium ?? 0)),
        recommendedValue: 4700,
        unitSymbol: foodRecords.firstOrNull
                ?.nutrientsSelectedSize()
                .potassium
                ?.symbol ??
            UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Polyunsaturated Fat',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalPolyunsaturatedFat ?? 0)),
        recommendedValue: 22,
        unitSymbol: foodRecords.firstOrNull
                ?.nutrientsSelectedSize()
                .polyunsaturatedFat
                ?.symbol ??
            UnitMassType.grams.symbol,
      ),
      MicroNutrient(
        name: 'Monounsaturated Fat',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalMonounsaturatedFat ?? 0)),
        recommendedValue: 44,
        unitSymbol: foodRecords.firstOrNull
                ?.nutrientsSelectedSize()
                .monounsaturatedFat
                ?.symbol ??
            UnitMassType.grams.symbol,
      ),
      MicroNutrient(
        name: 'Magnesium',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalMagnesium ?? 0)),
        recommendedValue: 420,
        unitSymbol: foodRecords.firstOrNull
                ?.nutrientsSelectedSize()
                .magnesium
                ?.symbol ??
            UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Iodine',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalIodine ?? 0)),
        recommendedValue: 150,
        unitSymbol:
            foodRecords.firstOrNull?.nutrientsSelectedSize().iodine?.symbol ??
                UnitMassType.micrograms.symbol,
      ),
      MicroNutrient(
        name: 'Vitamin B6',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalVitaminB6 ?? 0)),
        recommendedValue: 1.7,
        unitSymbol: foodRecords.firstOrNull
                ?.nutrientsSelectedSize()
                .vitaminB6
                ?.symbol ??
            UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Vitamin B12',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalVitaminB12 ?? 0)),
        recommendedValue: 2.4,
        unitSymbol: foodRecords.firstOrNull
                ?.nutrientsSelectedSize()
                .vitaminB12
                ?.symbol ??
            UnitMassType.micrograms.symbol,
      ),
      MicroNutrient(
        name: 'Vitamin E',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalVitaminE ?? 0)),
        recommendedValue: 15,
        unitSymbol:
            foodRecords.firstOrNull?.nutrientsSelectedSize().vitaminE?.symbol ??
                UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Vitamin A',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalVitaminA ?? 0)),
        recommendedValue: 3000,
        unitSymbol:
            foodRecords.firstOrNull?.nutrientsSelectedSize().vitaminA?.symbol ??
                'iu',
      ),
      MicroNutrient(
        name: 'Vitamin C',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalVitaminC ?? 0)),
        recommendedValue: 90,
        unitSymbol:
            foodRecords.firstOrNull?.nutrientsSelectedSize().vitaminC?.symbol ??
                UnitMassType.micrograms.symbol,
      ),
      MicroNutrient(
        name: 'Zinc',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalZinc ?? 0)),
        recommendedValue: 10,
        unitSymbol:
            foodRecords.firstOrNull?.nutrientsSelectedSize().zinc?.symbol ??
                UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Selenium',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalSelenium ?? 0)),
        recommendedValue: 55,
        unitSymbol:
            foodRecords.firstOrNull?.nutrientsSelectedSize().selenium?.symbol ??
                UnitMassType.micrograms.symbol,
      ),
      MicroNutrient(
        name: 'Folic Acid',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalFolicAcid ?? 0)),
        recommendedValue: 400,
        unitSymbol: foodRecords.firstOrNull
                ?.nutrientsSelectedSize()
                .folicAcid
                ?.symbol ??
            UnitMassType.micrograms.symbol,
      ),
      MicroNutrient(
        name: 'Chromium',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalChromium ?? 0)),
        recommendedValue: 35,
        unitSymbol:
            foodRecords.firstOrNull?.nutrientsSelectedSize().chromium?.symbol ??
                UnitMassType.micrograms.symbol,
      ),

      /// Need to update recommended value and default symbol.

      MicroNutrient(
        name: 'Alcohol',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalAlcohol ?? 0)),
        recommendedValue: 0,
        unitSymbol:
            foodRecords.firstOrNull?.nutrientsSelectedSize().alcohol?.symbol ??
                UnitMassType.micrograms.symbol,
      ),
      MicroNutrient(
        name: 'Phosphorus',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalPhosphorus ?? 0)),
        recommendedValue: 0,
        unitSymbol: foodRecords.firstOrNull
                ?.nutrientsSelectedSize()
                .phosphorus
                ?.symbol ??
            UnitMassType.micrograms.symbol,
      ),
      MicroNutrient(
        name: 'Alcohol Sugar',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalSugarsAlcohol ?? 0)),
        recommendedValue: 0,
        unitSymbol: foodRecords.firstOrNull
                ?.nutrientsSelectedSize()
                .sugarAlcohol
                ?.symbol ??
            UnitMassType.micrograms.symbol,
      ),
      MicroNutrient(
        name: 'Added Vitamin B12',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalVitaminB12Added ?? 0)),
        recommendedValue: 0,
        unitSymbol: foodRecords.firstOrNull
                ?.nutrientsSelectedSize()
                .vitaminB12Added
                ?.symbol ??
            UnitMassType.micrograms.symbol,
      ),
      MicroNutrient(
        name: 'Added Vitamin E',
        value: foodRecords.fold(
            0,
            (previousValue, element) =>
                previousValue + (element?.totalVitaminEAdded ?? 0)),
        recommendedValue: 0,
        unitSymbol: foodRecords.firstOrNull
                ?.nutrientsSelectedSize()
                .vitaminEAdded
                ?.symbol ??
            UnitMassType.micrograms.symbol,
      ),
      /*MicroNutrient(
        name: 'Vitamin K Phylloquinone',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalVitaminKPhylloquinone ?? 0)),
        recommendedValue: 0,
        unitSymbol: foodRecords.firstOrNull?.nutrientsSelectedSize().vitaminKPhylloquinone?.symbol ?? UnitMassType.micrograms.symbol,
      ),
      MicroNutrient(
        name: 'Vitamin K Menaquinone4',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalVitaminKMenaquinone4 ?? 0)),
        recommendedValue: 0,
        unitSymbol: foodRecords.firstOrNull?.nutrientsSelectedSize().vitaminKMenaquinone4?.symbol ?? UnitMassType.micrograms.symbol,
      ),
      MicroNutrient(
        name: 'Vitamin K Dihydrophylloquinone',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalVitaminKDihydrophylloquinone ?? 0)),
        recommendedValue: 0,
        unitSymbol: foodRecords.firstOrNull?.nutrientsSelectedSize().vitaminKDihydrophylloquinone?.symbol ?? UnitMassType.micrograms.symbol,
      ),*/
    ];
  }
}
