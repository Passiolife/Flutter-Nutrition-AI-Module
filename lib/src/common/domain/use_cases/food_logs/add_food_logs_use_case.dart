import '../../../../../nutrition_ai_module.dart';
import '../../../models/api_error.dart';
import '../../repository/food_log_repositoy.dart';
import '../use_case.dart';

class AddFoodLogsUseCase {
  final FoodLogRepository repository;

  const AddFoodLogsUseCase({required this.repository});

  Future<({void response, APIError? error})> call(
      List<FoodRecord> params) async {
    final futures = params
        .map((record) => repository.addFoodLog(foodRecord: record))
        .toList();
    await Future.wait(futures);
    return (response: null, error: null);
  }
}
