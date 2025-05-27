import '../../../models/food_record/food_record.dart';
import '../../../util/result.dart';
import '../../repository/passio_connector_repository.dart';
import '../use_case.dart';

class FetchDayRecordsUseCase extends UseCase<List<FoodRecord>, FetchDayRecordsParams> {
  final PassioConnectorRepository _repository;
  const FetchDayRecordsUseCase(PassioConnectorRepository repository) : _repository = repository;

  @override
  Future<Result<List<FoodRecord>>> call(FetchDayRecordsParams params) async {
    return await _repository.fetchDayRecords(dateTime: params.dateTime);
  }
}

class FetchDayRecordsParams {
  final DateTime dateTime;

  const FetchDayRecordsParams({required this.dateTime});
}
