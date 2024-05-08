import '../../util/date_time_utility.dart';
import '../user_profile/user_profile_model.dart';
import '../weight_day_log/weight_day_log.dart';
import '../weight_record/weight_record.dart';

class WeightDayLogs {
  List<WeightDayLog> dayLog = [];

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

  void fromDates(List<DateTime> dates) {
    for (var date in dates) {
      if (!dayLog.any((log) => log.date.isSameDate(date))) {
        dayLog.add(WeightDayLog(date: date));
      }
    }
    dayLog.sort((a, b) => a.date.compareTo(b.date));
  }

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
