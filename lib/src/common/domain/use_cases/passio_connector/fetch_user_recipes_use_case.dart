import '../../../models/food_record/food_record.dart';
import '../../../util/result.dart';
import '../../repository/passio_connector_repository.dart';
import '../use_case.dart';

class FetchUserRecipesUseCase extends UseCase<List<FoodRecord>, NoParams> {
  final PassioConnectorRepository _repository;

  const FetchUserRecipesUseCase({required PassioConnectorRepository repository})
      : _repository = repository;

  @override
  Future<Result<List<FoodRecord>>> call(NoParams params) async {
    return await _repository.fetchUserRecipes();
  }
}
