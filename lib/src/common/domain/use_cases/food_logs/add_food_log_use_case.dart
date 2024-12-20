import '../../../../../nutrition_ai_module.dart';
import '../../../data/repository/food_log_repositoy_impl.dart';

class AddFoodLogUseCase {
  FoodLogRepositoryImpl get _foodLogRepository => FoodLogRepositoryImpl();

  const AddFoodLogUseCase();

  Future<void> call({required FoodRecord foodRecord, required bool isNew}) async {
    await _foodLogRepository.addFoodLog(foodRecord, isNew);
  }
}
