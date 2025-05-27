import '../../../models/food_record/food_record.dart';
import '../../../util/result.dart';
import '../../repository/passio_connector_repository.dart';
import '../use_case.dart';

class UpdateRecordUseCase extends UseCase<void, UpdateRecordParams> {
  final PassioConnectorRepository _repository;

  const UpdateRecordUseCase({required PassioConnectorRepository repository})
      : _repository = repository;

  @override
  Future<Result<void>> call(UpdateRecordParams params) async {
    return await _repository.updateRecord(
        foodRecord: params.foodRecord, isNew: params.isNew);
  }
}

class UpdateRecordParams {
  final FoodRecord foodRecord;
  final bool isNew;

  const UpdateRecordParams({required this.foodRecord, required this.isNew});
}
