import 'dart:typed_data';

import '../../../util/result.dart';
import '../../repository/passio_connector_repository.dart';
import '../use_case.dart';

class FetchUserFoodImageUseCase
    extends UseCase<Uint8List?, FetchUserFoodImageParams> {
  final PassioConnectorRepository _repository;

  const FetchUserFoodImageUseCase(
      {required PassioConnectorRepository repository})
      : _repository = repository;

  @override
  Future<Result<Uint8List?>> call(FetchUserFoodImageParams params) async {
    return await _repository.fetchUserFoodImage(id: params.id);
  }
}

class FetchUserFoodImageParams {
  final String id;

  const FetchUserFoodImageParams({required this.id});
}
