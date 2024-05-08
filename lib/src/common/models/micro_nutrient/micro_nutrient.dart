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
    if (foodRecord == null) return [];
    return [
      MicroNutrient(
        name: 'Saturated Fat',
        value: foodRecord.totalSatFat,
        recommendedValue: 20,
        unitSymbol: foodRecord.nutrientsSelectedSize().satFat?.symbol ??
            UnitMassType.grams.symbol,
      ),
      MicroNutrient(
        name: 'Trans Fat',
        value: foodRecord.totalTransFat,
        recommendedValue: 0,
        unitSymbol: foodRecord.nutrientsSelectedSize().transFat?.symbol ??
            UnitMassType.grams.symbol,
      ),
      MicroNutrient(
        name: 'Cholesterol',
        value: foodRecord.totalCholesterol,
        recommendedValue: 300,
        unitSymbol: foodRecord.nutrientsSelectedSize().cholesterol?.symbol ??
            UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Sodium',
        value: foodRecord.totalSodium,
        recommendedValue: 2300,
        unitSymbol: foodRecord.nutrientsSelectedSize().sodium?.symbol ??
            UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Dietary Fiber',
        value: foodRecord.totalFibers,
        recommendedValue: 28,
        unitSymbol: foodRecord.nutrientsSelectedSize().fibers?.symbol ??
            UnitMassType.grams.symbol,
      ),
      MicroNutrient(
        name: 'Total Sugar',
        value: foodRecord.totalSugars,
        recommendedValue: 50,
        unitSymbol: foodRecord.nutrientsSelectedSize().sugars?.symbol ??
            UnitMassType.grams.symbol,
      ),
      MicroNutrient(
        name: 'Vitamin D',
        value: foodRecord.totalVitaminD,
        recommendedValue: 20,
        unitSymbol: foodRecord.nutrientsSelectedSize().vitaminD?.symbol ??
            UnitMassType.micrograms.symbol,
      ),
      MicroNutrient(
        name: 'Calcium',
        value: foodRecord.totalCalcium,
        recommendedValue: 1000,
        unitSymbol: foodRecord.nutrientsSelectedSize().calcium?.symbol ??
            UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Iron',
        value: foodRecord.totalIron,
        recommendedValue: 18,
        unitSymbol: foodRecord.nutrientsSelectedSize().iron?.symbol ??
            UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Potassium',
        value: foodRecord.totalPotassium,
        recommendedValue: 4700,
        unitSymbol: foodRecord.nutrientsSelectedSize().potassium?.symbol ??
            UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Polyunsaturated Fat',
        value: foodRecord.totalPolyunsaturatedFat,
        recommendedValue: 22,
        unitSymbol:
            foodRecord.nutrientsSelectedSize().polyunsaturatedFat?.symbol ??
                UnitMassType.grams.symbol,
      ),
      MicroNutrient(
        name: 'Monounsaturated Fat',
        value: foodRecord.totalMonounsaturatedFat,
        recommendedValue: 44,
        unitSymbol:
            foodRecord.nutrientsSelectedSize().monounsaturatedFat?.symbol ??
                UnitMassType.grams.symbol,
      ),
      MicroNutrient(
        name: 'Magnesium',
        value: foodRecord.totalMagnesium,
        recommendedValue: 420,
        unitSymbol: foodRecord.nutrientsSelectedSize().magnesium?.symbol ??
            UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Iodine',
        value: foodRecord.totalIodine,
        recommendedValue: 150,
        unitSymbol: foodRecord.nutrientsSelectedSize().iodine?.symbol ??
            UnitMassType.micrograms.symbol,
      ),
      MicroNutrient(
        name: 'Vitamin B6',
        value: foodRecord.totalVitaminB6,
        recommendedValue: 1.7,
        unitSymbol: foodRecord.nutrientsSelectedSize().vitaminB6?.symbol ??
            UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Vitamin B12',
        value: foodRecord.totalVitaminB12,
        recommendedValue: 2.4,
        unitSymbol: foodRecord.nutrientsSelectedSize().vitaminB12?.symbol ??
            UnitMassType.micrograms.symbol,
      ),
      MicroNutrient(
        name: 'Vitamin E',
        value: foodRecord.totalVitaminE,
        recommendedValue: 15,
        unitSymbol: foodRecord.nutrientsSelectedSize().vitaminE?.symbol ??
            UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Vitamin A',
        value: foodRecord.totalVitaminA,
        recommendedValue: 3000,
        unitSymbol: foodRecord.nutrientsSelectedSize().vitaminA?.symbol ?? 'iu',
      ),
      MicroNutrient(
        name: 'Vitamin C',
        value: foodRecord.totalVitaminC,
        recommendedValue: 90,
        unitSymbol: foodRecord.nutrientsSelectedSize().vitaminC?.symbol ??
            UnitMassType.micrograms.symbol,
      ),
      MicroNutrient(
        name: 'Zinc',
        value: foodRecord.totalZinc,
        recommendedValue: 10,
        unitSymbol: foodRecord.nutrientsSelectedSize().zinc?.symbol ?? UnitMassType.milligrams.symbol,
      ),
      MicroNutrient(
        name: 'Selenium',
        value: foodRecord.totalSelenium,
        recommendedValue: 55,
        unitSymbol: foodRecord.nutrientsSelectedSize().selenium?.symbol ?? UnitMassType.micrograms.symbol,
      ),
      MicroNutrient(
        name: 'Folic Acid',
        value: foodRecord.totalFolicAcid,
        recommendedValue: 400,
        unitSymbol: foodRecord.nutrientsSelectedSize().folicAcid?.symbol ?? UnitMassType.micrograms.symbol,
      ),
      MicroNutrient(
        name: 'Chromium',
        value: foodRecord.totalChromium,
        recommendedValue: 35,
        unitSymbol: foodRecord.nutrientsSelectedSize().chromium?.symbol ?? UnitMassType.micrograms.symbol,
      ),
    ];
  }
}
