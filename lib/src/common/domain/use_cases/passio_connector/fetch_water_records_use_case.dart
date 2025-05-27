import '../../../models/water_record/water_record.dart';
import '../../../util/result.dart';
import '../../repository/passio_connector_repository.dart';
import '../use_case.dart';

class FetchWaterRecordsUseCase
    extends UseCase<List<WaterRecord>, FetchWaterRecordsParams> {
  final PassioConnectorRepository _repository;

  const FetchWaterRecordsUseCase({
    required PassioConnectorRepository repository,
  }) : _repository = repository;

  @override
  Future<Result<List<WaterRecord>>> call(FetchWaterRecordsParams params) async {
    return await _repository.fetchWaterRecords(
        fromDate: params.fromDate, endDate: params.endDate);
  }
}

class FetchWaterRecordsParams {
  final DateTime fromDate;
  final DateTime endDate;

  const FetchWaterRecordsParams({
    required this.fromDate,
    required this.endDate,
  });
}
