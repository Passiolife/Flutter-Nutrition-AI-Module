import '../../util/date_time_utility.dart';
import '../day_log/day_log.dart';
import '../food_record/food_record.dart';

class DayLogs {
  List<DayLog> dayLog = [];

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

  double get consumedCalories => dayLog.fold(
      0, (previousValue, element) => previousValue + element.consumedCalories);

  double get consumedCarbs => dayLog.fold(
      0, (previousValue, element) => previousValue + element.consumedCarbs);

  double get consumedProteins => dayLog.fold(
      0, (previousValue, element) => previousValue + element.consumedProteins);

  double get consumedFat => dayLog.fold(
      0, (previousValue, element) => previousValue + element.consumedFat);
}
