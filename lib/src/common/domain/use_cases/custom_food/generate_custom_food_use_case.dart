import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../helper/custom_food_helper.dart';
import '../../../models/food_record/food_record_ingredient.dart';

class GenerateCustomFoodUseCase {
  FoodRecordIngredient call(
    FoodRecordIngredient? ingredient,
    String? id,
    String? name,
    String? iconId,
    double? selectedQuantity,
    String? selectedUnit,
    double? servingWeight,

    List<PassioServingUnit>? servingUnits,
    List<PassioServingSize>? servingSizes,
    UnitMass? weight,
    UnitMass? alcohol,
    UnitMass? calcium,
    UnitEnergy? calories,
    UnitMass? carbs,
    UnitMass? cholesterol,
    UnitMass? chromium,
    UnitMass? fat,
    UnitMass? fibers,
    UnitMass? folicAcid,
    UnitMass? iodine,
    UnitMass? iron,
    UnitMass? magnesium,
    UnitMass? monounsaturatedFat,
    UnitMass? phosphorus,
    UnitMass? polyunsaturatedFat,
    UnitMass? potassium,
    UnitMass? proteins,
    UnitMass? satFat,
    UnitMass? selenium,
    UnitMass? sodium,
    UnitMass? sugars,
    UnitMass? sugarsAdded,
    UnitMass? sugarAlcohol,
    UnitMass? transFat,
    UnitIU? vitaminA,
    UnitMass? vitaminB6,
    UnitMass? vitaminB12,
    UnitMass? vitaminB12Added,
    UnitMass? vitaminC,
    UnitMass? vitaminD,
    UnitMass? vitaminE,
    UnitMass? vitaminEAdded,
    UnitMass? vitaminKDihydrophylloquinone,
    UnitMass? vitaminKMenaquinone4,
    UnitMass? vitaminKPhylloquinone,
    UnitMass? vitaminARAE,
    UnitMass? zinc,
  ) {
    final newWeight = weight ?? ingredient?.referenceNutrients.referenceWeight;
    final newAlcohol = alcohol ?? ingredient?.referenceNutrients.alcohol;
    final newCalcium = calcium ?? ingredient?.referenceNutrients.calcium;
    final newCalories = calories ?? ingredient?.referenceNutrients.calories;
    final newCarbs = carbs ?? ingredient?.referenceNutrients.carbs;
    final newCholesterol =
        cholesterol ?? ingredient?.referenceNutrients.cholesterol;
    final newChromium = chromium ?? ingredient?.referenceNutrients.chromium;
    final newFat = fat ?? ingredient?.referenceNutrients.fat;
    final newFibers = fibers ?? ingredient?.referenceNutrients.fibers;
    final newFolicAcid = folicAcid ?? ingredient?.referenceNutrients.folicAcid;
    final newIodine = iodine ?? ingredient?.referenceNutrients.iodine;
    final newIron = iron ?? ingredient?.referenceNutrients.iron;
    final newMagnesium = magnesium ?? ingredient?.referenceNutrients.magnesium;
    final newMonounsaturatedFat =
        monounsaturatedFat ?? ingredient?.referenceNutrients.monounsaturatedFat;
    final newPhosphorus =
        phosphorus ?? ingredient?.referenceNutrients.phosphorus;
    final newPolyunsaturatedFat =
        polyunsaturatedFat ?? ingredient?.referenceNutrients.polyunsaturatedFat;
    final newPotassium = potassium ?? ingredient?.referenceNutrients.potassium;
    final newProteins = proteins ?? ingredient?.referenceNutrients.proteins;
    final newSatFat = satFat ?? ingredient?.referenceNutrients.satFat;
    final newSelenium = selenium ?? ingredient?.referenceNutrients.selenium;
    final newSodium = sodium ?? ingredient?.referenceNutrients.sodium;
    final newSugars = sugars ?? ingredient?.referenceNutrients.sugars;
    final newSugarsAdded =
        sugarsAdded ?? ingredient?.referenceNutrients.sugarsAdded;
    final newSugarAlcohol =
        sugarAlcohol ?? ingredient?.referenceNutrients.sugarAlcohol;
    final newTransFat = transFat ?? ingredient?.referenceNutrients.transFat;
    final newVitaminA = vitaminA ?? ingredient?.referenceNutrients.vitaminA;
    final newVitaminB6 = vitaminB6 ?? ingredient?.referenceNutrients.vitaminB6;
    final newVitaminB12 =
        vitaminB12 ?? ingredient?.referenceNutrients.vitaminB12;
    final newVitaminB12Added =
        vitaminB12Added ?? ingredient?.referenceNutrients.vitaminB12Added;
    final newVitaminC = vitaminC ?? ingredient?.referenceNutrients.vitaminC;
    final newVitaminD = vitaminD ?? ingredient?.referenceNutrients.vitaminD;
    final newVitaminE = vitaminE ?? ingredient?.referenceNutrients.vitaminE;
    final newVitaminEAdded =
        vitaminEAdded ?? ingredient?.referenceNutrients.vitaminEAdded;
    final newVitaminKDihydrophylloquinone = vitaminKDihydrophylloquinone ??
        ingredient?.referenceNutrients.vitaminKDihydrophylloquinone;
    final newVitaminKMenaquinone4 = vitaminKMenaquinone4 ??
        ingredient?.referenceNutrients.vitaminKMenaquinone4;
    final newVitaminKPhylloquinone = vitaminKPhylloquinone ??
        ingredient?.referenceNutrients.vitaminKPhylloquinone;
    final newVitaminARAE =
        vitaminARAE ?? ingredient?.referenceNutrients.vitaminARAE;
    final newZinc = zinc ?? ingredient?.referenceNutrients.zinc;

    final nutrients = PassioNutrients.fromNutrients(
      weight: newWeight,
      alcohol: newAlcohol,
      calcium: newCalcium,
      calories: newCalories,
      carbs: newCarbs,
      cholesterol: newCholesterol,
      chromium: newChromium,
      fat: newFat,
      fibers: newFibers,
      folicAcid: newFolicAcid,
      iodine: newIodine,
      iron: newIron,
      magnesium: newMagnesium,
      monounsaturatedFat: newMonounsaturatedFat,
      phosphorus: newPhosphorus,
      polyunsaturatedFat: newPolyunsaturatedFat,
      potassium: newPotassium,
      proteins: newProteins,
      satFat: newSatFat,
      selenium: newSelenium,
      sodium: newSodium,
      sugars: newSugars,
      sugarsAdded: newSugarsAdded,
      sugarAlcohol: newSugarAlcohol,
      transFat: newTransFat,
      vitaminA: newVitaminA,
      vitaminB6: newVitaminB6,
      vitaminB12: newVitaminB12,
      vitaminB12Added: newVitaminB12Added,
      vitaminC: newVitaminC,
      vitaminD: newVitaminD,
      vitaminE: newVitaminE,
      vitaminEAdded: newVitaminEAdded,
      vitaminKDihydrophylloquinone: newVitaminKDihydrophylloquinone,
      vitaminKMenaquinone4: newVitaminKMenaquinone4,
      vitaminKPhylloquinone: newVitaminKPhylloquinone,
      vitaminARAE: newVitaminARAE,
      zinc: newZinc,
    );

    final newSelectedQuantity = selectedQuantity ?? ingredient?.selectedQuantity ?? 1;
    final newSelectedUnit = selectedUnit ?? ingredient?.selectedUnit ?? 'gram';
    final newServingsWeight = servingWeight;
    final newServingUnits = servingUnits ?? CustomFoodHelper.generateCustomServingUnits(newSelectedUnit, newServingsWeight);

    return FoodRecordIngredient.fromCustomData(
      nutrients: nutrients,
      id: id ?? '',
      passioID: '',
      refCode: '',
      name: name ?? '',
      additionalData: '',
      iconId: iconId ?? CustomFoodHelper.generateIconId(),
      selectedQuantity: newSelectedQuantity,
      selectedUnit: newSelectedUnit,
      servingUnits: newServingUnits,
      servingSizes: [],
    );
  }
}
