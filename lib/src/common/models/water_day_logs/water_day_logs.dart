import '../../util/date_time_utility.dart';
import '../user_profile/user_profile_model.dart';
import '../water_day_log/water_day_log.dart';
import '../water_record/water_record.dart';

/// A collection of water day logs representing water consumption over multiple days.
class WaterDayLogs {
  /// List of water day logs.
  List<WaterDayLog> dayLog = [];

  /// Constructs a [WaterDayLogs] instance from a list of water consumption records.
  ///
  /// Parameters:
  ///   - records: The list of water consumption records.
  WaterDayLogs.from(List<WaterRecord> records) {
    for (var element in records) {
      final dateTime = DateTime.fromMillisecondsSinceEpoch(element.createdAt);

      final log = dayLog.cast<WaterDayLog?>().firstWhere(
          (element) => element?.date.isSameDate(dateTime) ?? false,
          orElse: () => null);
      if (log != null) {
        log.addRecord(element);
      } else {
        dayLog.add(WaterDayLog(date: dateTime, records: [element]));
      }
    }
  }

  /// Adds water day logs for the provided dates if they don't already exist.
  ///
  /// Parameters:
  ///   - dates: List of dates for which water day logs need to be added.
  void fromDates(List<DateTime> dates) {
    for (var date in dates) {
      if (!dayLog.any((log) => log.date == date)) {
        dayLog.add(WaterDayLog(date: date));
      }
    }
    dayLog.sort((a, b) => a.date.compareTo(b.date));
  }

  /// Calculates the total amount of consumed water over all days in the logs.
  ///
  /// Parameters:
  ///   - unit: The measurement system to use for the calculation.
  ///
  /// Returns:
  ///   The total amount of consumed water over all days, measured according to the specified [unit].
  double getConsumedWater(MeasurementSystem unit) => dayLog.fold(
      0,
      (previousValue, element) =>
          previousValue + element.getConsumedWater(unit));
}
