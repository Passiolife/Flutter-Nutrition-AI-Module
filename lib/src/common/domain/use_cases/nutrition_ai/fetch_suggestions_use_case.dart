import 'package:nutrition_ai/nutrition_ai.dart' as nutrition_ai;

import '../../../util/result.dart';
import '../../repository/nutrition_ai_repository.dart';
import '../use_case.dart';

class FetchSuggestionsUseCase extends UseCase<List<nutrition_ai.PassioFoodDataInfo>, FetchSuggestionsParams> {
  final NutritionAIRepository _repository;
  const FetchSuggestionsUseCase({required NutritionAIRepository repository}) : _repository = repository;

  @override
  Future<Result<List<nutrition_ai.PassioFoodDataInfo>>> call(FetchSuggestionsParams params) async {
    return await _repository.fetchSuggestions(mealTime: params.mealTime);
  }
}

class FetchSuggestionsParams {
  final nutrition_ai.PassioMealTime mealTime;

  const FetchSuggestionsParams({required this.mealTime});
}