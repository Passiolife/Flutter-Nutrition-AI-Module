import '../../../models/food_record/food_record.dart';
import '../../../util/result.dart';
import '../../repository/passio_connector_repository.dart';
import '../use_case.dart';

class FetchUserFoodsUseCase extends UseCase<List<FoodRecord>, NoParams> {
  final PassioConnectorRepository _repository;
  const FetchUserFoodsUseCase({required PassioConnectorRepository repository}) : _repository = repository;

  @override
  Future<Result<List<FoodRecord>>> call(NoParams params) async {
    return await _repository.fetchUserFoods();
  }
}