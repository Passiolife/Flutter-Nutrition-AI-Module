import '../user_profile/user_profile_model.dart';
import '../water_record/water_record.dart';

class WaterDayLog {
  final DateTime date;
  final List<WaterRecord> records;

  const WaterDayLog({required this.date, this.records = const []});

  double getConsumedWater(MeasurementSystem unit) {
    return records.fold(
        0,
        (previousValue, element) =>
            previousValue + element.getWater(unit: unit));
  }

  void addRecord(WaterRecord record) {
    records.add(record);
  }
}
