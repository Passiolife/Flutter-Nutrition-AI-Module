import 'package:nutrition_ai/nutrition_ai.dart';

import 'passio_food_metadata_extension.dart';
import 'passio_ingredient_extension.dart';

extension PassioFoodItemUpdater on PassioFoodItem {
  PassioFoodItem copyWith({
    PassioFoodAmount? amount,
    String? details,
    String? iconId,
    String? id,
    List<PassioIngredient>? ingredients,
    String? name,
    String? refCode,
    PassioID? scannedId,
  }) {
    return PassioFoodItem(
      amount: amount ?? this.amount,
      details: details ?? this.details,
      iconId: iconId ?? this.iconId,
      id: id ?? this.id,
      ingredients: ingredients ?? this.ingredients,
      name: name ?? this.name,
      refCode: refCode ?? this.refCode,
      scannedId: scannedId ?? this.scannedId,
    );
  }

  PassioFoodItem updateIngredientsDescription(String ingredientsDescription) {
    final firstIngredient = ingredients.firstOrNull;
    if (firstIngredient == null) {
      return this;
    }
    final newMetaData = firstIngredient.metadata.copyWith(
      ingredientsDescription: ingredientsDescription,
    );
    final newFirstIngredient = firstIngredient.copyWith(metadata: newMetaData);
    final newIngredients = [
      newFirstIngredient,
      ...ingredients.skip(1),
    ];
    return copyWith(
      ingredients: newIngredients,
    );
  }
}

extension FoodItemNutritionExtensions on PassioFoodItem {
  bool get hasMacros {
    final referenceNutrients = ingredients.firstOrNull?.referenceNutrients;
    return referenceNutrients != null &&
        (referenceNutrients.calories != null ||
            referenceNutrients.carbs != null ||
            referenceNutrients.proteins != null ||
            referenceNutrients.fat != null);
  }

  bool get hasFullMacros {
    final referenceNutrients = ingredients.firstOrNull?.referenceNutrients;
    return referenceNutrients != null &&
        referenceNutrients.calories != null &&
        referenceNutrients.carbs != null &&
        referenceNutrients.proteins != null &&
        referenceNutrients.fat != null;
  }

  bool get hasServingSize {
    return amount.selectedQuantity > 0 && amount.selectedUnit.isNotEmpty;
  }

  bool get hasNutritionFacts {
    return hasFullMacros && hasServingSize;
  }

  bool get hasIngredientsDescription {
    return ingredients
            .firstOrNull?.metadata.ingredientsDescription?.isNotEmpty ??
        false;
  }
}
