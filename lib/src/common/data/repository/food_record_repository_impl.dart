import '../../../../nutrition_ai_module.dart';

class FoodRecordRepositoryImpl {
  Future<FoodRecord?> convertFoodRecord({
    required PassioFoodDataInfo foodDataInfo,
  }) async {
    final foodItem =
        await NutritionAI.instance.fetchFoodItemForDataInfo(foodDataInfo);
    if (foodItem == null) {
      return null;
    }
    return FoodRecord.fromPassioFoodItem(foodItem);
  }
}
