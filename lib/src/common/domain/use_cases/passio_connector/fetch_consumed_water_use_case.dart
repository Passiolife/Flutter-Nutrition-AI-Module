import '../../../util/result.dart';
import '../../repository/passio_connector_repository.dart';
import '../use_case.dart';

class FetchConsumedWaterUseCase
    extends UseCase<double, FetchConsumedWaterParams> {
  final PassioConnectorRepository _repository;

  const FetchConsumedWaterUseCase({
    required PassioConnectorRepository repository,
  }) : _repository = repository;

  @override
  Future<Result<double>> call(FetchConsumedWaterParams params) async {
    return await _repository.fetchConsumedWater(dateTime: params.dateTime);
  }
}

class FetchConsumedWaterParams {
  final DateTime dateTime;

  const FetchConsumedWaterParams({required this.dateTime});
}
