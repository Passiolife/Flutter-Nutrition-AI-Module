import '../../../../../nutrition_ai_module.dart';
import '../../../data/repository/food_record_repository_impl.dart';

class ConvertFoodDataInfoToFoodRecordUseCase {
  FoodRecordRepositoryImpl get _foodRecordRepository =>
      FoodRecordRepositoryImpl();

  const ConvertFoodDataInfoToFoodRecordUseCase();

  Future<FoodRecord?> call({required PassioFoodDataInfo foodDataInfo}) async {
    return await _foodRecordRepository.convertFoodRecord(
        foodDataInfo: foodDataInfo);
  }
}
