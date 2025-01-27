import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../extension/null_safety_extension.dart';
import '../../../extension/string_extensions.dart';
import '../../../helper/custom_food_helper.dart';
import '../../../models/food_record/food_record_ingredient.dart';

class CreateCustomFoodIngredientUseCase {
  Future<FoodRecordIngredient> call({
    FoodRecordIngredient? ingredient,
    String? id,
    String? name,
    String? iconId,
    double? selectedQuantity,
    String? selectedUnit,
    double? servingWeight,
    List<PassioServingUnit>? servingUnits,
    List<PassioServingSize>? servingSizes,
    String? openFoodLicense,
    String? barcode,
    PassioIDEntityType? entityType,
    PassioFoodResultType? resultType,
    double? alcohol,
    double? calcium,
    double? calories,
    double? carbs,
    double? cholesterol,
    double? chromium,
    double? fat,
    double? fibers,
    double? folicAcid,
    double? iodine,
    double? iron,
    double? magnesium,
    double? monounsaturatedFat,
    double? phosphorus,
    double? polyunsaturatedFat,
    double? potassium,
    double? proteins,
    double? satFat,
    double? selenium,
    double? sodium,
    double? sugars,
    double? sugarsAdded,
    double? sugarAlcohol,
    double? transFat,
    double? vitaminA,
    double? vitaminB6,
    double? vitaminB12,
    double? vitaminB12Added,
    double? vitaminC,
    double? vitaminD,
    double? vitaminE,
    double? vitaminEAdded,
    double? vitaminKDihydrophylloquinone,
    double? vitaminKMenaquinone4,
    double? vitaminKPhylloquinone,
    double? vitaminARAE,
    double? zinc,
  }) async {

    final referenceWeight = ingredient?.referenceNutrients.referenceWeight ?? UnitMass(100, UnitMassType.grams);
    if(selectedUnit == 'gram') {
      servingWeight = selectedQuantity;
    }
    final newServingWeight = UnitMass(
        servingWeight ?? referenceWeight.value,
        UnitMassType.grams
    );
    final normalizedNewServingWeight = UnitMass(
        servingWeight != null ? servingWeight / (selectedQuantity ?? 1) : referenceWeight.value,
        UnitMassType.grams
    );

    final alcoholUnit = alcohol?.let((it) => UnitMass(it, UnitMassType.grams));
    final calciumUnit = calcium?.let((it) => UnitMass(it, UnitMassType.grams));
    final caloriesUnit = calories?.let((it) => UnitEnergy(it, UnitEnergyType.kilocalories));
    final carbsUnit = carbs?.let((it) => UnitMass(it, UnitMassType.grams));
    final cholesterolUnit = cholesterol?.let((it) => UnitMass(it, UnitMassType.grams));
    final chromiumUnit = chromium?.let((it) => UnitMass(it, UnitMassType.grams));
    final fatUnit = fat?.let((it) => UnitMass(it, UnitMassType.grams));
    final fibersUnit = fibers?.let((it) => UnitMass(it, UnitMassType.grams));
    final folicAcidUnit = folicAcid?.let((it) => UnitMass(it, UnitMassType.grams));
    final iodineUnit = iodine?.let((it) => UnitMass(it, UnitMassType.grams));
    final ironUnit = iron?.let((it) => UnitMass(it, UnitMassType.grams));
    final magnesiumUnit = magnesium?.let((it) => UnitMass(it, UnitMassType.grams));
    final monounsaturatedFatUnit = monounsaturatedFat?.let((it) => UnitMass(it, UnitMassType.grams));
    final phosphorusUnit = phosphorus?.let((it) => UnitMass(it, UnitMassType.grams));
    final polyunsaturatedFatUnit = polyunsaturatedFat?.let((it) => UnitMass(it, UnitMassType.grams));
    final potassiumUnit = potassium?.let((it) => UnitMass(it, UnitMassType.grams));
    final proteinsUnit = proteins?.let((it) => UnitMass(it, UnitMassType.grams));
    final satFatUnit = satFat?.let((it) => UnitMass(it, UnitMassType.grams));
    final seleniumUnit = selenium?.let((it) => UnitMass(it, UnitMassType.grams));
    final sodiumUnit = sodium?.let((it) => UnitMass(it, UnitMassType.grams));
    final sugarsUnit = sugars?.let((it) => UnitMass(it, UnitMassType.grams));
    final sugarsAddedUnit = sugarsAdded?.let((it) => UnitMass(it, UnitMassType.grams));
    final sugarAlcoholUnit = sugarAlcohol?.let((it) => UnitMass(it, UnitMassType.grams));
    final transFatUnit = transFat?.let((it) => UnitMass(it, UnitMassType.grams));
    final vitaminAUnit = vitaminA?.let((it) => UnitIU(it));
    final vitaminB6Unit = vitaminB6?.let((it) => UnitMass(it, UnitMassType.grams));
    final vitaminB12Unit = vitaminB12?.let((it) => UnitMass(it, UnitMassType.grams));
    final vitaminB12AddedUnit = vitaminB12Added?.let((it) => UnitMass(it, UnitMassType.grams));
    final vitaminCUnit = vitaminC?.let((it) => UnitMass(it, UnitMassType.grams));
    final vitaminDUnit = vitaminD?.let((it) => UnitMass(it, UnitMassType.grams));
    final vitaminEUnit = vitaminE?.let((it) => UnitMass(it, UnitMassType.grams));
    final vitaminEAddedUnit = vitaminEAdded?.let((it) => UnitMass(it, UnitMassType.grams));
    final vitaminKDihydrophylloquinoneUnit = vitaminKDihydrophylloquinone?.let((it) => UnitMass(it, UnitMassType.grams));
    final vitaminKMenaquinone4Unit = vitaminKMenaquinone4?.let((it) => UnitMass(it, UnitMassType.grams));
    final vitaminKPhylloquinoneUnit = vitaminKPhylloquinone?.let((it) => UnitMass(it, UnitMassType.grams));
    final vitaminARAEUnit = vitaminARAE?.let((it) => UnitMass(it, UnitMassType.grams));
    final zincUnit = zinc?.let((it) => UnitMass(it, UnitMassType.grams));

    final newNutrients = PassioNutrients.fromNutrients(
      weight: newServingWeight,
      alcohol: alcoholUnit,
      calcium: calciumUnit,
      calories: caloriesUnit,
      carbs: carbsUnit,
      cholesterol: cholesterolUnit,
      chromium: chromiumUnit,
      fat: fatUnit,
      fibers: fibersUnit,
      folicAcid: folicAcidUnit,
      iodine: iodineUnit,
      iron: ironUnit,
      magnesium: magnesiumUnit,
      monounsaturatedFat: monounsaturatedFatUnit,
      phosphorus: phosphorusUnit,
      polyunsaturatedFat: polyunsaturatedFatUnit,
      potassium: potassiumUnit,
      proteins: proteinsUnit,
      satFat: satFatUnit,
      selenium: seleniumUnit,
      sodium: sodiumUnit,
      sugars: sugarsUnit,
      sugarsAdded: sugarsAddedUnit,
      sugarAlcohol: sugarAlcoholUnit,
      transFat: transFatUnit,
      vitaminA: vitaminAUnit,
      vitaminB6: vitaminB6Unit,
      vitaminB12: vitaminB12Unit,
      vitaminB12Added: vitaminB12AddedUnit,
      vitaminC: vitaminCUnit,
      vitaminD: vitaminDUnit,
      vitaminE: vitaminEUnit,
      vitaminEAdded: vitaminEAddedUnit,
      vitaminKDihydrophylloquinone: vitaminKDihydrophylloquinoneUnit,
      vitaminKMenaquinone4: vitaminKMenaquinone4Unit,
      vitaminKPhylloquinone: vitaminKPhylloquinoneUnit,
      vitaminARAE: vitaminARAEUnit,
      zinc: zincUnit,
    );

    final newAlcohol = newNutrients.alcohol ?? ingredient?.referenceNutrients.alcohol;
    final newCalcium = newNutrients.calcium ?? ingredient?.referenceNutrients.calcium;
    final newCalories = newNutrients.calories ?? ingredient?.referenceNutrients.calories;
    final newCarbs = newNutrients.carbs ?? ingredient?.referenceNutrients.carbs;
    final newCholesterol =
        newNutrients.cholesterol ?? ingredient?.referenceNutrients.cholesterol;
    final newChromium = newNutrients.chromium ?? ingredient?.referenceNutrients.chromium;
    final newFat = newNutrients.fat ?? ingredient?.referenceNutrients.fat;
    final newFibers = newNutrients.fibers ?? ingredient?.referenceNutrients.fibers;
    final newFolicAcid = newNutrients.folicAcid ?? ingredient?.referenceNutrients.folicAcid;
    final newIodine = newNutrients.iodine ?? ingredient?.referenceNutrients.iodine;
    final newIron = newNutrients.iron ?? ingredient?.referenceNutrients.iron;
    final newMagnesium = newNutrients.magnesium ?? ingredient?.referenceNutrients.magnesium;
    final newMonounsaturatedFat =
        newNutrients.monounsaturatedFat ?? ingredient?.referenceNutrients.monounsaturatedFat;
    final newPhosphorus =
        newNutrients.phosphorus ?? ingredient?.referenceNutrients.phosphorus;
    final newPolyunsaturatedFat =
        newNutrients.polyunsaturatedFat ?? ingredient?.referenceNutrients.polyunsaturatedFat;
    final newPotassium = newNutrients.potassium ?? ingredient?.referenceNutrients.potassium;
    final newProteins = newNutrients.proteins ?? ingredient?.referenceNutrients.proteins;
    final newSatFat = newNutrients.satFat ?? ingredient?.referenceNutrients.satFat;
    final newSelenium = newNutrients.selenium ?? ingredient?.referenceNutrients.selenium;
    final newSodium = newNutrients.sodium ?? ingredient?.referenceNutrients.sodium;
    final newSugars = newNutrients.sugars ?? ingredient?.referenceNutrients.sugars;
    final newSugarsAdded =
        newNutrients.sugarsAdded ?? ingredient?.referenceNutrients.sugarsAdded;
    final newSugarAlcohol =
        newNutrients.sugarAlcohol ?? ingredient?.referenceNutrients.sugarAlcohol;
    final newTransFat = newNutrients.transFat ?? ingredient?.referenceNutrients.transFat;
    final newVitaminA = newNutrients.vitaminA ?? ingredient?.referenceNutrients.vitaminA;
    final newVitaminB6 = newNutrients.vitaminB6 ?? ingredient?.referenceNutrients.vitaminB6;
    final newVitaminB12 =
        newNutrients.vitaminB12 ?? ingredient?.referenceNutrients.vitaminB12;
    final newVitaminB12Added =
        newNutrients.vitaminB12Added ?? ingredient?.referenceNutrients.vitaminB12Added;
    final newVitaminC = newNutrients.vitaminC ?? ingredient?.referenceNutrients.vitaminC;
    final newVitaminD = newNutrients.vitaminD ?? ingredient?.referenceNutrients.vitaminD;
    final newVitaminE = newNutrients.vitaminE ?? ingredient?.referenceNutrients.vitaminE;
    final newVitaminEAdded =
        newNutrients.vitaminEAdded ?? ingredient?.referenceNutrients.vitaminEAdded;
    final newVitaminKDihydrophylloquinone = newNutrients.vitaminKDihydrophylloquinone ??
        ingredient?.referenceNutrients.vitaminKDihydrophylloquinone;
    final newVitaminKMenaquinone4 = newNutrients.vitaminKMenaquinone4 ??
        ingredient?.referenceNutrients.vitaminKMenaquinone4;
    final newVitaminKPhylloquinone = newNutrients.vitaminKPhylloquinone ??
        ingredient?.referenceNutrients.vitaminKPhylloquinone;
    final newVitaminARAE =
        newNutrients.vitaminARAE ?? ingredient?.referenceNutrients.vitaminARAE;
    final newZinc = newNutrients.zinc ?? ingredient?.referenceNutrients.zinc;

    final nutrients = PassioNutrients.fromNutrients(
      weight: referenceWeight,
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
    final newSelectedUnit = (selectedUnit.isNotNullOrEmpty ? selectedUnit : ingredient?.selectedUnit) ?? 'gram';
    final newServingUnits = servingUnits ?? CustomFoodHelper.generateCustomServingUnits(newSelectedUnit, normalizedNewServingWeight.value);
    final newServingSizes = servingSizes ?? CustomFoodHelper.generateCustomServingSizes(newSelectedUnit);

    final newOpenFoodLicense = openFoodLicense ?? ingredient?.openFoodLicense;
    final newBarcode = barcode ?? ingredient?.barcode;

    final newEntityType = entityType ?? ingredient?.entityType ?? PassioIDEntityType.item;
    final newResultType = resultType ?? ingredient?.resultType ?? PassioFoodResultType.foodItem;

    return FoodRecordIngredient.fromCustomData(
      nutrients: nutrients,
      id: id ?? '',
      passioID: '',
      refCode: '',
      name: name ?? '',
      additionalData: '',
      iconId: iconId.isNotNullOrEmpty ? iconId! : CustomFoodHelper.generateIconId(),
      selectedQuantity: newSelectedQuantity,
      selectedUnit: newSelectedUnit,
      servingUnits: newServingUnits,
      servingSizes: newServingSizes,
      entityType: newEntityType,
      openFoodLicense: newOpenFoodLicense,
      barcode: newBarcode,
      resultType: newResultType,
    );
  }
}
