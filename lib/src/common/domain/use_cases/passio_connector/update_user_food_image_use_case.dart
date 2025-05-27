import 'dart:typed_data';

import '../../../util/result.dart';
import '../../repository/passio_connector_repository.dart';
import '../use_case.dart';

class UpdateUserFoodImageUseCase
    extends UseCase<void, UpdateUserFoodImageParams> {
  final PassioConnectorRepository _repository;

  const UpdateUserFoodImageUseCase(
      {required PassioConnectorRepository repository})
      : _repository = repository;

  @override
  Future<Result<void>> call(UpdateUserFoodImageParams params) async {
    return await _repository.updateUserFoodImage(
      id: params.id,
      image: params.image,
      isNew: params.isNew,
    );
  }
}

class UpdateUserFoodImageParams {
  final String id;
  final Uint8List image;
  final bool isNew;

  const UpdateUserFoodImageParams({
    required this.id,
    required this.image,
    required this.isNew,
  });
}
