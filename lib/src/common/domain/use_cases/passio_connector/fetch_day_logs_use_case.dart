import '../../../models/day_logs/day_logs.dart';
import '../../../util/result.dart';
import '../use_case.dart';
import 'fetch_records_use_case.dart' as useCase;

class FetchDayLogsUseCase extends UseCase<DayLogs?, Params> {
  final useCase.FetchRecordsUseCase _useCase;

  const FetchDayLogsUseCase({required useCase.FetchRecordsUseCase useCase})
      : _useCase = useCase;

  @override
  Future<Result<DayLogs?>> call(Params params) async {
    final result = await _useCase.call(useCase.FetchRecordsParams(fromDate: params.fromDate, endDate: params.endDate));

    switch (result) {
      case Success():
        final DayLogs dayLogs = DayLogs.from(result.value);
        return Result.success(dayLogs);
        break;
      case Error():
        return Result.error(result.error);
    }
  }
}

class Params {
  final DateTime fromDate;
  final DateTime endDate;

  const Params({required this.fromDate, required this.endDate});
}