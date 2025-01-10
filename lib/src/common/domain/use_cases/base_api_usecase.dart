import '../../models/api_error.dart';

mixin BaseApiUseCase<Response, Params> {
  Future<({Response? response, APIError? error})> call(Params params);
}

class NoParams {}