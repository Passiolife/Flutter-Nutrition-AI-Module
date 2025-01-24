import 'dart:typed_data';

import 'package:nutrition_ai/nutrition_ai.dart';

import '../../domain/repository/nutrition_ai_repository.dart';

class NutritionAIRepositoryImpl extends NutritionAIRepository {
  const NutritionAIRepositoryImpl();

  @override
  Future<List<PassioAdvisorFoodInfo>> recognizeImage(Uint8List image,
      {PassioImageResolution resolution = PassioImageResolution.res_512,
      String? message}) {
    return NutritionAI.instance.recognizeImageRemote(
      image,
      resolution: resolution,
      message: message,
    );
  }

  @override
  Future<List<PassioAdvisorFoodInfo>> recognizeImages(List<Uint8List> images,
      {PassioImageResolution resolution = PassioImageResolution.res_512,
      String? message}) async {
    return (await Future.wait(
            images.map((image) async => recognizeImage(image))))
        .expand<PassioAdvisorFoodInfo>((e) => e)
        .toList();
  }

  @override
  Future<PassioFoodItem?> fetchFoodItemForDataInfo(
      PassioFoodDataInfo foodDataInfo,
      {double? servingQuantity,
      String? servingUnit}) async {
    final quantity =
        servingQuantity ?? foodDataInfo.nutritionPreview.servingQuantity;
    final unit = servingUnit ?? foodDataInfo.nutritionPreview.servingUnit;
    return await NutritionAI.instance.fetchFoodItemForDataInfo(
      foodDataInfo,
      servingQuantity: quantity,
      servingUnit: unit,
    );
  }

  @override
  Future<List<PassioFoodItem>> fetchFoodItemForDataInfos(
      List<PassioFoodDataInfo?> foodDataInfo,
      {List<({double? servingQuantity, String? servingUnit})>?
          servingSizes}) async {
    final foodDataInfos = foodDataInfo.whereType<PassioFoodDataInfo>();
    return (await Future.wait(foodDataInfos
            .map((foodData) async => await fetchFoodItemForDataInfo(foodData))))
        .whereType<PassioFoodItem>()
        .toList();
  }

  @override
  Future<PassioFoodItem?> recognizeNutritionFacts(Uint8List bytes,
      {PassioImageResolution resolution = PassioImageResolution.res_1080}) {
    return NutritionAI.instance
        .recognizeNutritionFactsRemote(bytes, resolution: resolution);
  }

  @override
  Future<void> enableFlashlight(bool enabled) async {
    return NutritionAI.instance.enableFlashlight(enabled: enabled);
  }

  @override
  Future<PassioFoodItem?> fetchFoodItemForProductCode(
      String productCode) async {
    return await NutritionAI.instance.fetchFoodItemForProductCode(productCode);
  }
}
