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

    var futuresItemRecords =
        recognizedData.where((e) => e.foodDataInfo != null).map((e) async {
          final foodData = e.foodDataInfo;
          if(foodData == null) return null;
          final foodItem = await repository.fetchFoodItemForDataInfo(foodData);
          if(foodItem == null) return null;
          return FoodRecord.fromPassioFoodItem(
            foodItem,
            resultType: e.resultType,
          );
        }).toList();

    // Use Future.wait to resolve all futures and filter out nulls
    List<FoodRecord> itemRecords = (await Future.wait(futuresItemRecords)).whereType<FoodRecord>().toList();

    List<FoodRecord> packagedFoodRecords = recognizedData
        .where((e) => e.packagedFoodItem != null)
        .map((e) => FoodRecord.fromPassioFoodItem(
              e.packagedFoodItem!,
              resultType: e.resultType,
            ))
        .toList();

    final foodRecords = itemRecords + packagedFoodRecords;

    return (response: foodRecords, error: null);
  }
}
