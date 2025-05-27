import '../../../models/food_record/food_record.dart';
import '../../../util/result.dart';
import '../../repository/passio_connector_repository.dart';
import '../use_case.dart';

class FetchRecordsUseCase extends UseCase<List<FoodRecord>, FetchRecordsParams> {
  final PassioConnectorRepository _repository;
  const FetchRecordsUseCase({required PassioConnectorRepository repository}) : _repository = repository;

  @override
  Future<Result<List<FoodRecord>>> call(FetchRecordsParams params) async {
    return await _repository.fetchRecords(fromDate: params.fromDate, endDate: params.endDate);
  }
}

class FetchRecordsParams {
  final DateTime fromDate;
  final DateTime endDate;

  const FetchRecordsParams({required this.fromDate, required this.endDate});
}
