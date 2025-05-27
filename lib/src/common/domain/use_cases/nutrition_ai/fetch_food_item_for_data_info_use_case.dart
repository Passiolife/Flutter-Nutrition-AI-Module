import 'package:nutrition_ai/nutrition_ai.dart' as nutrition_ai;

import '../../../util/result.dart';
import '../../repository/nutrition_ai_repository.dart';
import '../use_case.dart';

class FetchFoodItemForDataInfoUseCase extends UseCase<nutrition_ai.PassioFoodItem?, FetchFoodItemForDataInfoParams> {
  final NutritionAIRepository _repository;
  const FetchFoodItemForDataInfoUseCase({required NutritionAIRepository repository}) : _repository = repository;

  @override
  Future<Result<nutrition_ai.PassioFoodItem?>> call(FetchFoodItemForDataInfoParams params) async {
    return await _repository.fetchFoodItemForDataInfo(foodDataInfo: params.foodDataInfo, servingQuantity: params.servingQuantity, servingUnit: params.servingUnit);
  }
}

class FetchFoodItemForDataInfoParams {
  final nutrition_ai.PassioFoodDataInfo foodDataInfo;
  final double? servingQuantity;
  final String? servingUnit;

  const FetchFoodItemForDataInfoParams({required this.foodDataInfo, this.servingQuantity, this.servingUnit});
}