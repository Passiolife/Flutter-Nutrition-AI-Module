import '../user_profile/user_profile_model.dart';
import '../weight_record/weight_record.dart';

class WeightDayLog {
  final DateTime date;
  final List<WeightRecord> records;

  const WeightDayLog({required this.date, this.records = const []});

  double getMeasuredWeight(MeasurementSystem? unit) {
    return records.fold(
        0,
        (previousValue, element) =>
            previousValue + element.getWeight(unit: unit));
  }

  void addRecord(WeightRecord record) {
    records.add(record);
  }
}
