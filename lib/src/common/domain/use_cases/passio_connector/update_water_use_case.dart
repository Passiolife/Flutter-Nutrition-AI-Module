import '../../../models/water_record/water_record.dart';
import '../../../util/result.dart';
import '../../repository/passio_connector_repository.dart';
import '../use_case.dart';

class UpdateWaterUseCase extends UseCase<void, UpdateWaterParams> {
  final PassioConnectorRepository _repository;

  const UpdateWaterUseCase({
    required PassioConnectorRepository repository,
  }) : _repository = repository;

  @override
  Future<Result<void>> call(UpdateWaterParams params) async {
    return await _repository.updateWater(
        waterRecord: params.waterRecord, isNew: params.isNew);
  }
}

class UpdateWaterParams {
  final WaterRecord waterRecord;
  final bool isNew;

  const UpdateWaterParams({
    required this.waterRecord,
    required this.isNew,
  });
}
