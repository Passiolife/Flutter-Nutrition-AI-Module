import '../../../models/water_record/water_record.dart';
import '../../../util/result.dart';
import '../../repository/passio_connector_repository.dart';
import '../use_case.dart';

class DeleteWaterRecordUseCase extends UseCase<void, DeleteWaterRecordParams> {
  final PassioConnectorRepository _repository;

  const DeleteWaterRecordUseCase({
    required PassioConnectorRepository repository,
  }) : _repository = repository;

  @override
  Future<Result<void>> call(DeleteWaterRecordParams params) async {
    return await _repository.deleteWater(waterRecord: params.record);
  }
}

class DeleteWaterRecordParams {
  final WaterRecord record;

  const DeleteWaterRecordParams({required this.record});
}
