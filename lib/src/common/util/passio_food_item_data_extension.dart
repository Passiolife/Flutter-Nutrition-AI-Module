/*
import 'package:nutrition_ai/nutrition_ai.dart';

import 'double_extensions.dart';

UnitEnergy? actualUnitEnergy(
    PassioFoodItemData foodItemData, UnitEnergy? unitEnergy) {
  if (unitEnergy != null) {
    double actualUnitEnergy = (unitEnergy.value) /
        (foodItemData.computedWeight().gramsValue() / 100).roundNumber(2);
    return UnitEnergy(actualUnitEnergy, unitEnergy.unit);
  }
  return unitEnergy;
}

UnitMass? actualUnitMass(PassioFoodItemData foodItemData, UnitMass? unitMass) {
  if (unitMass != null) {
    double actualUnitMass = (unitMass.value) /
        (foodItemData.computedWeight().gramsValue() / 100).roundNumber(2);
    return UnitMass(actualUnitMass, unitMass.unit);
  }
  return null;
}

UnitIU? actualUnitIU(PassioFoodItemData foodItemData, UnitIU? unitIU) {
  if (unitIU != null) {
    double actualUnitMass = (unitIU.value) /
        (foodItemData.computedWeight().gramsValue() / 100).roundNumber(2);
    return UnitIU(actualUnitMass);
  }
  return null;
}

extension PassioFoodItemDataExtension on PassioFoodItemData {
  PassioFoodItemData copyWith({
    PassioID? passioID,
    String? name,
    double? selectedQuantity,
    String? selectedUnit,
    PassioIDEntityType? entityType,
    List<PassioServingUnit>? servingUnits,
    List<PassioServingSize>? servingSize,
    String? ingredientsDescription,
    Barcode? barcode,
    List<PassioFoodOrigin>? foodOrigins,
    List<PassioAlternative>? parents,
    List<PassioAlternative>? siblings,
    List<PassioAlternative>? children,
    List<String>? tags,
    UnitMass? referenceWeight,
    UnitEnergy? calories,
    UnitMass? carbs,
    UnitMass? fat,
    UnitMass? proteins,
    UnitMass? saturatedFat,
    UnitMass? transFat,
    UnitMass? monounsaturatedFat,
    UnitMass? polyunsaturatedFat,
    UnitMass? cholesterol,
    UnitMass? sodium,
    UnitMass? fibers,
    UnitMass? sugars,
    UnitMass? sugarsAdded,
    UnitMass? vitaminD,
    UnitMass? calcium,
    UnitMass? iron,
    UnitMass? potassium,
    UnitIU? vitaminA,
    UnitMass? vitaminC,
    UnitMass? alcohol,
    UnitMass? sugarAlcohol,
    UnitMass? vitaminB12Added,
    UnitMass? vitaminB12,
    UnitMass? vitaminB6,
    UnitMass? vitaminE,
    UnitMass? vitaminEAdded,
    UnitMass? magnesium,
    UnitMass? phosphorus,
    UnitMass? iodine,
  }) {
    return PassioFoodItemData(
      passioID ?? this.passioID,
      name ?? this.name,
      tags ?? this.tags,
      selectedQuantity ?? this.selectedQuantity,
      selectedUnit ?? this.selectedUnit,
      entityType ?? this.entityType,
      servingUnits ?? this.servingUnits,
      servingSize ?? this.servingSize,
      ingredientsDescription ?? this.ingredientsDescription,
      barcode ?? this.barcode,
      foodOrigins ?? this.foodOrigins,
      parents ?? this.parents,
      siblings ?? this.siblings,
      children ?? this.children,
      calories ?? actualUnitEnergy(this, totalCalories()),
      carbs ?? actualUnitMass(this, totalCarbs()),
      fat ?? actualUnitMass(this, totalFat()),
      proteins ?? actualUnitMass(this, totalProteins()),
      saturatedFat ?? actualUnitMass(this, totalSaturatedFat()),
      transFat ?? actualUnitMass(this, totalTransFat()),
      monounsaturatedFat ?? actualUnitMass(this, totalMonounsaturatedFat()),
      polyunsaturatedFat ?? actualUnitMass(this, totalPolyunsaturatedFat()),
      cholesterol ?? actualUnitMass(this, totalCholesterol()),
      sodium ?? actualUnitMass(this, totalSodium()),
      fibers ?? actualUnitMass(this, totalFibers()),
      sugars ?? actualUnitMass(this, totalSugars()),
      sugarsAdded ?? actualUnitMass(this, totalSugarsAdded()),
      vitaminD ?? actualUnitMass(this, totalVitaminD()),
      calcium ?? actualUnitMass(this, totalCalcium()),
      iron ?? actualUnitMass(this, totalIron()),
      potassium ?? actualUnitMass(this, totalPotassium()),
      vitaminA ?? actualUnitIU(this, totalVitaminA()),
      vitaminC ?? actualUnitMass(this, totalVitaminC()),
      alcohol ?? actualUnitMass(this, totalAlcohol()),
      sugarAlcohol ?? actualUnitMass(this, totalSugarAlcohol()),
      vitaminB12Added ?? actualUnitMass(this, totalVitaminB12Added()),
      vitaminB12 ?? actualUnitMass(this, totalVitaminB12()),
      vitaminB6 ?? actualUnitMass(this, totalVitaminB6()),
      vitaminE ?? actualUnitMass(this, totalVitaminE()),
      vitaminEAdded ?? actualUnitMass(this, totalVitaminEAdded()),
      magnesium ?? actualUnitMass(this, totalMagnesium()),
      phosphorus ?? actualUnitMass(this, totalPhosphorus()),
      iodine ?? actualUnitMass(this, totalIodine()),
    );
  }
}
*/
