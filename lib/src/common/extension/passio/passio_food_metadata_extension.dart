import 'package:nutrition_ai/nutrition_ai.dart';

extension PassioFoodItemUpdater on PassioFoodMetadata {
  PassioFoodMetadata copyWith({
    String? barcode,
    List<PassioFoodOrigin>? foodOrigins,
    String? ingredientsDescription,
    List<String>? tags,
  }) {
    return PassioFoodMetadata(
      barcode: barcode ?? this.barcode,
      foodOrigins: foodOrigins ?? this.foodOrigins,
      ingredientsDescription: ingredientsDescription ?? this.ingredientsDescription,
      tags: tags ?? this.tags,
    );
  }
}