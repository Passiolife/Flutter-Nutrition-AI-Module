import 'dart:typed_data';

import 'package:nutrition_ai/nutrition_ai.dart';

abstract class NutritionAIRepository {
  Future<List<PassioAdvisorFoodInfo>> recognizeImage(Uint8List image,
      {PassioImageResolution resolution = PassioImageResolution.res_512,
        String? message});

  Future<List<PassioAdvisorFoodInfo>> recognizeImages(List<Uint8List> images,
      {PassioImageResolution resolution = PassioImageResolution.res_512,
        String? message});

  Future<PassioFoodItem?> fetchFoodItemForDataInfo(
      PassioFoodDataInfo foodDataInfo,
      {double? servingQuantity,
        String? servingUnit});

  Future<List<PassioFoodItem>> fetchFoodItemForDataInfos(
      List<PassioFoodDataInfo?> foodDataInfo,
      {List<({double? servingQuantity, String? servingUnit})>? servingSizes});

  Future<PassioFoodItem?> recognizeNutritionFacts(Uint8List bytes,
      {PassioImageResolution resolution =
          PassioImageResolution.res_1080});
}
