import 'package:nutrition_ai/nutrition_ai.dart';

import '../food_record/food_record.dart';

class MicroNutrient {
  final String name;
  final double value;
  final double recommendedValue;
  final String unitSymbol;

  MicroNutrient({
    required this.name,
    required this.value,
    required this.recommendedValue,
    required this.unitSymbol,
  });

  static List<MicroNutrient> nutrientsFromFoodRecord(FoodRecord? foodRecord) {
    return nutrientsFromFoodRecords([foodRecord]);
  }

  static List<MicroNutrient> nutrientsFromFoodRecords(List<FoodRecord?>? foodRecords) {
    if (foodRecords == null) return [];
    return [
      MicroNutrient(
        name: 'Saturated Fat',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalSatFat ?? 0)),
        recommendedValue: 20,
        unitSymbol: foodRecords.firstOrNull?.nutrientsSelectedSize().satFat?.symbol ??
            UnitMassType.grams.symbol,
      ),
      MicroNutrient(
        name: 'Trans Fat',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalTransFat ?? 0)),
        recommendedValue: 0,
        unitSymbol: foodRecords.firstOrNull?.nutrientsSelectedSize().transFat?.symbol ??
            UnitMassType.grams.symbol,
      ),
      MicroNutrient(
        name: 'Cholesterol',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalCholesterol ?? 0)),
        recommendedValue: 300,
        unitSymbol: foodRecords.firstOrNull?.nutrientsSelectedSize().cholesterol?.symbol ??
            UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Sodium',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalSodium ?? 0)),
        recommendedValue: 2300,
        unitSymbol: foodRecords.firstOrNull?.nutrientsSelectedSize().sodium?.symbol ??
            UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Dietary Fiber',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalFibers ?? 0)),
        recommendedValue: 28,
        unitSymbol: foodRecords.firstOrNull?.nutrientsSelectedSize().fibers?.symbol ??
            UnitMassType.grams.symbol,
      ),
      MicroNutrient(
        name: 'Total Sugar',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalSugars ?? 0)),
        recommendedValue: 50,
        unitSymbol: foodRecords.firstOrNull?.nutrientsSelectedSize().sugars?.symbol ??
            UnitMassType.grams.symbol,
      ),
      MicroNutrient(
        name: 'Vitamin D',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalVitaminD ?? 0)),
        recommendedValue: 20,
        unitSymbol: foodRecords.firstOrNull?.nutrientsSelectedSize().vitaminD?.symbol ??
            UnitMassType.micrograms.symbol,
      ),
      MicroNutrient(
        name: 'Calcium',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalCalcium ?? 0)),
        recommendedValue: 1000,
        unitSymbol: foodRecords.firstOrNull?.nutrientsSelectedSize().calcium?.symbol ??
            UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Iron',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalIron ?? 0)),
        recommendedValue: 18,
        unitSymbol: foodRecords.firstOrNull?.nutrientsSelectedSize().iron?.symbol ??
            UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Potassium',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalPotassium ?? 0)),
        recommendedValue: 4700,
        unitSymbol: foodRecords.firstOrNull?.nutrientsSelectedSize().potassium?.symbol ??
            UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Polyunsaturated Fat',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalPolyunsaturatedFat ?? 0)),
        recommendedValue: 22,
        unitSymbol:
        foodRecords.firstOrNull?.nutrientsSelectedSize().polyunsaturatedFat?.symbol ??
                UnitMassType.grams.symbol,
      ),
      MicroNutrient(
        name: 'Monounsaturated Fat',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalMonounsaturatedFat ?? 0)),
        recommendedValue: 44,
        unitSymbol:
        foodRecords.firstOrNull?.nutrientsSelectedSize().monounsaturatedFat?.symbol ??
                UnitMassType.grams.symbol,
      ),
      MicroNutrient(
        name: 'Magnesium',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalMagnesium ?? 0)),
        recommendedValue: 420,
        unitSymbol: foodRecords.firstOrNull?.nutrientsSelectedSize().magnesium?.symbol ??
            UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Iodine',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalIodine ?? 0)),
        recommendedValue: 150,
        unitSymbol: foodRecords.firstOrNull?.nutrientsSelectedSize().iodine?.symbol ??
            UnitMassType.micrograms.symbol,
      ),
      MicroNutrient(
        name: 'Vitamin B6',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalVitaminB6 ?? 0)),
        recommendedValue: 1.7,
        unitSymbol: foodRecords.firstOrNull?.nutrientsSelectedSize().vitaminB6?.symbol ??
            UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Vitamin B12',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalVitaminB12 ?? 0)),
        recommendedValue: 2.4,
        unitSymbol: foodRecords.firstOrNull?.nutrientsSelectedSize().vitaminB12?.symbol ??
            UnitMassType.micrograms.symbol,
      ),
      MicroNutrient(
        name: 'Vitamin E',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalVitaminE ?? 0)),
        recommendedValue: 15,
        unitSymbol: foodRecords.firstOrNull?.nutrientsSelectedSize().vitaminE?.symbol ??
            UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Vitamin A',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalVitaminA ?? 0)),
        recommendedValue: 3000,
        unitSymbol: foodRecords.firstOrNull?.nutrientsSelectedSize().vitaminA?.symbol ?? 'iu',
      ),
      MicroNutrient(
        name: 'Vitamin C',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalVitaminC ?? 0)),
        recommendedValue: 90,
        unitSymbol: foodRecords.firstOrNull?.nutrientsSelectedSize().vitaminC?.symbol ??
            UnitMassType.micrograms.symbol,
      ),
      MicroNutrient(
        name: 'Zinc',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalZinc ?? 0)),
        recommendedValue: 10,
        unitSymbol: foodRecords.firstOrNull?.nutrientsSelectedSize().zinc?.symbol ?? UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Selenium',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalSelenium ?? 0)),
        recommendedValue: 55,
        unitSymbol: foodRecords.firstOrNull?.nutrientsSelectedSize().selenium?.symbol ?? UnitMassType.micrograms.symbol,
      ),
      MicroNutrient(
        name: 'Folic Acid',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalFolicAcid ?? 0)),
        recommendedValue: 400,
        unitSymbol: foodRecords.firstOrNull?.nutrientsSelectedSize().folicAcid?.symbol ?? UnitMassType.micrograms.symbol,
      ),
      MicroNutrient(
        name: 'Chromium',
        value: foodRecords.fold(0, (previousValue, element) => previousValue + (element?.totalChromium ?? 0)),
        recommendedValue: 35,
        unitSymbol: foodRecords.firstOrNull?.nutrientsSelectedSize().chromium?.symbol ?? UnitMassType.micrograms.symbol,
      ),
    ];
  }
}
