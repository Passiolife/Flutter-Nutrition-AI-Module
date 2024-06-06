import '../user_profile/user_profile_model.dart';
import '../weight_record/weight_record.dart';

/// A class representing a log of weight records for a specific day.
class WeightDayLog {
  /// The date for which the weight log is recorded.
  final DateTime date;

  /// List of weight records for the day.
  final List<WeightRecord> records;

  /// Constructs a [WeightDayLog] instance with the specified date and optional list of weight records.
  ///
  /// Parameters:
  ///   - [date]: The date for which the weight log is recorded.
  ///   - [records]: List of weight records for the day. Defaults to an empty list.
  const WeightDayLog({
    required this.date,
    this.records = const [],
  });

  /// Retrieves the total measured weight for the day.
  ///
  /// Parameters:
  ///   - [unit]: The measurement system used for retrieving the weight. Defaults to null, indicating the default measurement system.
  ///
  /// Returns:
  ///   The total measured weight for the day, optionally converted based on the specified [unit].
  double getMeasuredWeight(MeasurementSystem? unit) {
    return records.fold(
        0,
        (previousValue, element) =>
            previousValue + element.getWeight(unit: unit));
  }

  /// Adds a new weight record to the day log.
  ///
  /// Parameters:
  ///   - [record]: The weight record to add.
  void addRecord(WeightRecord record) {
    records.add(record);
  }
}
