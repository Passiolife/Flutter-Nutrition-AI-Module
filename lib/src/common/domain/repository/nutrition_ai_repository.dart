import 'dart:typed_data';

import 'package:nutrition_ai/nutrition_ai.dart';

import '../../util/result.dart';

abstract class NutritionAIRepository {
  const NutritionAIRepository();

  Future<List<PassioAdvisorFoodInfo>> recognizeImage(Uint8List image,
      {PassioImageResolution resolution = PassioImageResolution.res_512,
      String? message});

  Future<List<PassioAdvisorFoodInfo>> recognizeImages(List<Uint8List> images,
      {PassioImageResolution resolution = PassioImageResolution.res_512,
      String? message});

  Future<Result<PassioFoodItem?>> fetchFoodItemForDataInfo({
    required PassioFoodDataInfo foodDataInfo,
    double? servingQuantity,
    String? servingUnit,
  });

  // Future<List<PassioFoodItem>> fetchFoodItemForDataInfos(
  //     List<PassioFoodDataInfo?> foodDataInfo,
  //     {List<({double? servingQuantity, String? servingUnit})>? servingSizes});

  Future<PassioFoodItem?> recognizeNutritionFacts(Uint8List bytes,
      {PassioImageResolution resolution = PassioImageResolution.res_1080});

  Future<void> enableFlashlight(bool enabled);

  Future<PassioFoodItem?> fetchFoodItemForProductCode(String productCode);

  Future<Result<List<PassioFoodDataInfo>>> fetchSuggestions(
      {required PassioMealTime mealTime});
}
