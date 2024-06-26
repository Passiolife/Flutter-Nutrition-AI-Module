import '../../util/date_time_utility.dart';
import '../day_log/day_log.dart';
import '../food_record/food_record.dart';

/// A collection of daily logs, each containing a list of food records consumed on that day.
class DayLogs {
  /// List of daily logs.
  List<DayLog> dayLog = [];

  /// Constructs a [DayLogs] object from a list of food records.
  ///
  /// Each food record is added to the corresponding daily log based on its date.
  DayLogs.from(List<FoodRecord> foodRecords) {
    for (var element in foodRecords) {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(
          element.getCreatedAt()?.millisecondsSinceEpoch ?? 0);

      DayLog? log = dayLog.cast<DayLog?>().firstWhere(
          (element) => element?.date.isSameDate(dateTime) ?? false,
          orElse: () => null);

      if (log != null) {
        log.addRecord(element);
      } else {
        dayLog.add(DayLog(date: dateTime, records: [element]));
      }
    }
  }

  /// Total consumed calories across all daily logs.
  double get consumedCalories => dayLog.fold(
      0, (previousValue, element) => previousValue + element.consumedCalories);

  /// Total consumed carbohydrates across all daily logs.
  double get consumedCarbs => dayLog.fold(
      0, (previousValue, element) => previousValue + element.consumedCarbs);

  /// Total consumed proteins across all daily logs.
  double get consumedProteins => dayLog.fold(
      0, (previousValue, element) => previousValue + element.consumedProteins);

  /// Total consumed fat across all daily logs.
  double get consumedFat => dayLog.fold(
      0, (previousValue, element) => previousValue + element.consumedFat);
}
