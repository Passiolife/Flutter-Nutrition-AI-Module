// Define the repository interface
import 'dart:typed_data';

import 'package:nutrition_ai/nutrition_ai.dart';

import '../../models/food_record/food_record.dart';

abstract class FoodRepository {
  Future<List<FoodRecord?>> getFoodRecordsByImageRecognition(
      List<Uint8List>? images);
}

// Implement the repository
class FoodRepositoryImpl implements FoodRepository {
  @override
  Future<List<FoodRecord?>> getFoodRecordsByImageRecognition(
      List<Uint8List>? images) async {
    if (images == null) {
      return [];
    }

    final recognizedData = (await Future.wait(images
            .map((e) async => NutritionAI.instance.recognizeImageRemote(e))))
        .expand((e) => e);

    final foodRecords = await Future.wait(
      recognizedData.map<Future<FoodRecord?>>((passioFoodDataInfo) async {
        final foodDataInfo = passioFoodDataInfo.foodDataInfo;
        final nutritionPreview = foodDataInfo?.nutritionPreview;
        if (foodDataInfo == null) return null;

        final foodItem = await NutritionAI.instance.fetchFoodItemForDataInfo(
          foodDataInfo,
          servingQuantity: nutritionPreview?.servingQuantity,
          servingUnit: nutritionPreview?.servingUnit,
        );
        if (foodItem == null) return null;

        return FoodRecord.fromPassioFoodItem(foodItem);
      }),
    );

    return foodRecords;
  }
}
