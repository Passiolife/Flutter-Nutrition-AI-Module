import '../../../models/food_record/food_record.dart';
import '../../../util/result.dart';
import '../../repository/passio_connector_repository.dart';
import '../use_case.dart';

class FetchMeasuredWeightUseCase extends UseCase<double, FetchMeasuredWeightParams> {
  final PassioConnectorRepository _repository;
  const FetchMeasuredWeightUseCase({required PassioConnectorRepository repository}) : _repository = repository;

  @override
  Future<Result<double>> call(FetchMeasuredWeightParams params) async {
    return await _repository.fetchMeasuredWeight(dateTime: params.dateTime);
  }
}

class FetchMeasuredWeightParams {
  final DateTime dateTime;

  const FetchMeasuredWeightParams({required this.dateTime});
}
