import '../user_profile/user_profile_model.dart';
import '../water_record/water_record.dart';

/// A class representing a log of water consumption for a specific day.
class WaterDayLog {
  /// The date associated with this water day log.
  final DateTime date;

  /// List of water consumption records for the day.
  final List<WaterRecord> records;

  /// Constructs a [WaterDayLog] with the given date and optional list of records.
  const WaterDayLog({
    required this.date,
    this.records = const [],
  });

  /// Calculates the total amount of consumed water for the day.
  ///
  /// Parameters:
  ///   - unit: The measurement system to use for the calculation.
  ///
  /// Returns:
  ///   The total amount of consumed water for the day, measured according to the specified [unit].
  double getConsumedWater(MeasurementSystem unit) {
    return records.fold(
        0,
        (previousValue, element) =>
            previousValue + element.getWater(unit: unit));
  }

  /// Adds a water consumption record to the day log.
  ///
  /// Parameters:
  ///   - record: The water consumption record to add.
  void addRecord(WaterRecord record) {
    records.add(record);
  }
}
