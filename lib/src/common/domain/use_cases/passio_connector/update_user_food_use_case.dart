import '../../../models/food_record/food_record.dart';
import '../../../util/result.dart';
import '../../repository/passio_connector_repository.dart';
import '../use_case.dart';

class UpdateUserFoodUseCase extends UseCase<void, UpdateUserFoodParams> {
  final PassioConnectorRepository _repository;

  const UpdateUserFoodUseCase({required PassioConnectorRepository repository})
      : _repository = repository;

  @override
  Future<Result<void>> call(UpdateUserFoodParams params) async {
    return await _repository.updateUserFood(
        foodRecord: params.foodRecord, isNew: params.isNew);
  }
}

class UpdateUserFoodParams {
  final FoodRecord foodRecord;
  final bool isNew;

  const UpdateUserFoodParams({required this.foodRecord, required this.isNew});
}