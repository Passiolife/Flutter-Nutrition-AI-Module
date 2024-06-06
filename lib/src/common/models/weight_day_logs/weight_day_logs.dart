import '../../util/date_time_utility.dart';
import '../user_profile/user_profile_model.dart';
import '../weight_day_log/weight_day_log.dart';
import '../weight_record/weight_record.dart';

/// A class representing a collection of weight day logs.
class WeightDayLogs {
  /// List of weight day logs.
  List<WeightDayLog> dayLog = [];

  /// Constructs a [WeightDayLogs] instance from a list of weight records.
  ///
  /// This constructor organizes weight records into daily logs.
  ///
  /// Parameters:
  ///   - [records]: The list of weight records to be processed.
  WeightDayLogs.from(List<WeightRecord> records) {
    for (var element in records) {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(element.createdAt);

      final log = dayLog.cast<WeightDayLog?>().firstWhere(
          (element) => element?.date.isSameDate(dateTime) ?? false,
          orElse: () => null);
      if (log != null) {
        log.addRecord(element);
      } else {
        dayLog.add(WeightDayLog(date: dateTime, records: [element]));
      }
    }
  }

  /// Constructs weight day logs from a list of dates.
  ///
  /// This method creates weight day logs for each date in the provided list if they don't already exist.
  ///
  /// Parameters:
  ///   - [dates]: The list of dates to be processed.
  void fromDates(List<DateTime> dates) {
    for (var date in dates) {
      if (!dayLog.any((log) => log.date.isSameDate(date))) {
        dayLog.add(WeightDayLog(date: date));
      }
    }
    dayLog.sort((a, b) => a.date.compareTo(b.date));
  }

  /// Retrieves the measured weight from the latest recorded day log.
  ///
  /// Parameters:
  ///   - [unit]: The measurement system used for retrieving the weight. Defaults to null, indicating the default measurement system.
  ///
  /// Returns:
  ///   The measured weight from the latest recorded day log, optionally converted based on the specified [unit].
  double getMeasuredWeight(MeasurementSystem? unit) =>
      dayLog
          .expand((element) => element.records)
          .cast<WeightRecord?>()
          .fold<WeightRecord?>(
              null,
              (current, next) =>
                  DateTime.fromMillisecondsSinceEpoch(next?.createdAt ?? 0)
                          .isAfter(
                    DateTime.fromMillisecondsSinceEpoch(
                        current?.createdAt ?? 0),
                  )
                      ? next
                      : current)
          ?.getWeight(unit: unit) ??
      0;
}
