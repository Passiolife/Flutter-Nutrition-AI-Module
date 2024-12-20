import '../../../../nutrition_ai_module.dart';

class FoodSelectionResult {
  final PassioFoodDataInfo? foodDataInfo;
  final FoodRecord? foodRecord;
  final bool fromAdd;

  const FoodSelectionResult({
    this.foodDataInfo,
    this.foodRecord,
    this.fromAdd = false,
  });
}
