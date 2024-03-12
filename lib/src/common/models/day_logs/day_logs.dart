import '../day_log/day_log.dart';

class DayLogs {
  List<DayLog> dayLog = [];

//   DayLogs.from(List<FoodRecord> foodRecords) {
//     for (var element in foodRecords) {
//       final dateTime =
//           DateTime.fromMillisecondsSinceEpoch(element.createdAt?.toInt() ?? 0);
//
//       DayLog? log = dayLog.cast<DayLog?>().firstWhere(
//           (element) => element?.date.isSameDate(dateTime) ?? false,
//           orElse: () => null);
//
//       if (log != null) {
//         log.addRecord(element);
//       } else {
//         dayLog.add(DayLog(dateTime, [element]));
//       }
//     }
//   }
}
