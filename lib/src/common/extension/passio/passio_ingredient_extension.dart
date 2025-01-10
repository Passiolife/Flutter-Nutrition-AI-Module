import 'package:nutrition_ai/nutrition_ai.dart';

extension PassioIngredientUpdater on PassioIngredient {
  PassioIngredient copyWith({
    PassioFoodAmount? amount,
    String? iconId,
    String? id,
    PassioFoodMetadata? metadata,
    String? name,
    String? refCode,
    PassioNutrients? referenceNutrients,
  }) {
    return PassioIngredient(
      amount: amount ?? this.amount,
      iconId: iconId ?? this.iconId,
      id: id ?? this.id,
      metadata: metadata ?? this.metadata,
      name: name ?? this.name,
      refCode: refCode ?? this.refCode,
      referenceNutrients: referenceNutrients ?? this.referenceNutrients,
    );
  }
}
