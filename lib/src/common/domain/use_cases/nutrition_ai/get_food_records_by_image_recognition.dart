import 'dart:typed_data';

import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../models/api_error.dart';
import '../../../models/food_record/food_record.dart';
import '../../repository/nutrition_ai_repository.dart';
import '../base_api_usecase.dart';

class GetFoodRecordsByImageRecognition
    with BaseApiUseCase<List<FoodRecord>, List<Uint8List>?> {
  final NutritionAIRepository repository;

  const GetFoodRecordsByImageRecognition({required this.repository});

  @override
  Future<({APIError? error, List<FoodRecord> response})> call(
      List<Uint8List>? params) async {
    if (params == null) {
      return (response: <FoodRecord>[], error: null);
    }

    final recognizedData = await repository.recognizeImages(params);

    final foodDataInfos = recognizedData
        .map((e) => e.foodDataInfo)
        .whereType<PassioFoodDataInfo>()
        .toList();
    final packagedFoods = recognizedData
        .map((e) => e.packagedFoodItem)
        .toList()
        .whereType<PassioFoodItem>()
        .toList();

    List<PassioFoodItem> foodItems = [];
    if (foodDataInfos.isNotEmpty) {
      foodItems = await repository.fetchFoodItemForDataInfos(foodDataInfos);
    }

    final mergedFoodItems = foodItems + packagedFoods;

    final foodRecords =
        mergedFoodItems.map((e) => FoodRecord.fromPassioFoodItem(e)).toList();

    return (response: foodRecords, error: null);
  }
}
