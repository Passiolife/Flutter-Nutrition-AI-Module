import '../../util/date_time_utility.dart';
import '../user_profile/user_profile_model.dart';
import '../water_day_log/water_day_log.dart';
import '../water_record/water_record.dart';

class WaterDayLogs {
  List<WaterDayLog> dayLog = [];

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

  void fromDates(List<DateTime> dates) {
    for (var date in dates) {
      if (!dayLog.any((log) => log.date == date)) {
        dayLog.add(WaterDayLog(date: date));
      }
    }
    dayLog.sort((a,b) => a.date.compareTo(b.date));
  }

  double getConsumedWater(MeasurementSystem unit) => dayLog.fold(0, (previousValue, element) => previousValue + element.getConsumedWater(unit));

}
