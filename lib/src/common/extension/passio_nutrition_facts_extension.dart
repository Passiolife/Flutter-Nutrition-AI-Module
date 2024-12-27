import 'package:nutrition_ai/nutrition_ai.dart';

import 'null_safety_extension.dart';

extension PassioNutritionFactsExtension on PassioNutritionFacts {
  PassioFoodItem toPassioFoodItem() {
    final passioIngredient = toPassioIngredient();
    return PassioFoodItem(
      amount: passioIngredient.amount,
      details: '',
      iconId: passioIngredient.iconId,
      id: passioIngredient.id,
      ingredients: [passioIngredient],
      name: passioIngredient.name,
      refCode: passioIngredient.refCode,
    );
  }

  PassioIngredient toPassioIngredient() {
    double selectedQuantity = servingQuantity ?? 1;
    final selectedUnit = servingUnit ?? 'gram';
    double weight = weightQuantity ?? 0;

    double normalizedWeight = _normalizeWeight(weight, selectedQuantity);
    final servingSizes = _getServingSizes(selectedUnit);
    final servingUnits = _getServingUnits(selectedUnit, normalizedWeight);

    final amount = PassioFoodAmount(
      selectedQuantity: selectedQuantity,
      selectedUnit: selectedUnit,
      servingSizes: servingSizes,
      servingUnits: servingUnits,
    );

    final metadata = PassioFoodMetadata();
    final referenceNutrients = _buildReferenceNutrients(weight);

    return PassioIngredient(
      amount: amount,
      iconId: '',
      id: '',
      metadata: metadata,
      name: '',
      refCode: '',
      referenceNutrients: referenceNutrients,
    );
  }

  double _normalizeWeight(double weight, double selectedQuantity) {
    return (weight / selectedQuantity) * 1;
  }

  List<PassioServingSize> _getServingSizes(String selectedUnit) {
    return [
      if (selectedUnit.isNotEmpty && selectedUnit != 'gram')
        PassioServingSize(1.0, selectedUnit),
      PassioServingSize(100, 'gram'),
    ];
  }

  List<PassioServingUnit> _getServingUnits(String selectedUnit, double normalizedWeight) {
    return [
      if (selectedUnit.isNotEmpty && selectedUnit != 'gram')
        PassioServingUnit(
            selectedUnit, UnitMass(normalizedWeight, UnitMassType.grams)),
      PassioServingUnit('gram', UnitMass(1, UnitMassType.grams)),
    ];
  }

  PassioNutrients _buildReferenceNutrients(double weight) {
    weight = weight > 0 ? weight : 100;
    return PassioNutrients.fromNutrients(
      weight: UnitMass(weight, UnitMassType.grams),
      calories:
      calories?.let((it) => UnitEnergy(it, UnitEnergyType.kilocalories)),
      carbs: carbs.let((it) => UnitMass(it, UnitMassType.grams)),
      fat: fat.let((it) => UnitMass(it, UnitMassType.grams)),
      proteins: protein.let((it) => UnitMass(it, UnitMassType.grams)),
      satFat: saturatedFat.let((it) => UnitMass(it, UnitMassType.grams)),
      transFat: transFat.let((it) => UnitMass(it, UnitMassType.grams)),
      cholesterol:
      cholesterol.let((it) => UnitMass(it, UnitMassType.milligrams)),
      sodium: sodium.let((it) => UnitMass(it, UnitMassType.milligrams)),
      fibers: dietaryFiber.let((it) => UnitMass(it, UnitMassType.grams)),
      sugars: sugars.let((it) => UnitMass(it, UnitMassType.grams)),
      sugarsAdded: addedSugar.let((it) => UnitMass(it, UnitMassType.grams)),
      vitaminD: vitaminD.let((it) => UnitMass(it, UnitMassType.micrograms)),
      calcium: calcium.let((it) => UnitMass(it, UnitMassType.milligrams)),
      potassium: potassium.let((it) => UnitMass(it, UnitMassType.milligrams)),
      iron: iron.let((it) => UnitMass(it, UnitMassType.milligrams)),
      sugarAlcohol: sugarAlcohol.let((it) => UnitMass(it, UnitMassType.grams)),
    );
  }
}
