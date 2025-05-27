import '../../../models/food_record/food_record.dart';
import '../../../util/result.dart';
import '../../repository/passio_connector_repository.dart';
import '../use_case.dart';

class DeleteUserFoodRecordUseCase extends UseCase<void, DeleteUserFoodRecordParams> {
  final PassioConnectorRepository _repository;

  const DeleteUserFoodRecordUseCase({
    required PassioConnectorRepository repository,
  }) : _repository = repository;

  @override
  Future<Result<void>> call(DeleteUserFoodRecordParams params) async {
    return await _repository.deleteUserFood(foodRecord: params.record);
  }
}

class DeleteUserFoodRecordParams {
  final FoodRecord record;

  const DeleteUserFoodRecordParams({required this.record});
}
