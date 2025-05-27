import '../../models/api_error.dart';
import '../../util/result.dart';

abstract class UseCase<Response, Params> {
  const UseCase();

  Future<Result<Response>> call(Params params);
}

class NoParams {
  const NoParams();
}