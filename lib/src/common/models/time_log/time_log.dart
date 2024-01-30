import '../../util/double_extensions.dart';
import '../food_record/food_record.dart';

class TimeLog {
  final DateTime dateTime;
  final List<FoodRecord?> foodRecords;

  TimeLog({required this.dateTime, required this.foodRecords});

  /// Methods for the total macros.
  double get totalCalories {
    return foodRecords
        .map((e) => e?.totalCalories)
        .reduce((value, element) => (value ?? 0) + (element ?? 0))
        .roundNumber(1);
  }

  double get totalCarbs {
    return foodRecords
        .map((e) => e?.totalCarbs)
        .reduce((value, element) => (value ?? 0) + (element ?? 0))
        .roundNumber(1);
  }

  double get totalProteins {
    return foodRecords
        .map((e) => e?.totalProteins)
        .reduce((value, element) => (value ?? 0) + (element ?? 0))
        .roundNumber(1);
  }

  double get totalFat {
    return foodRecords
        .map((e) => e?.totalFat)
        .reduce((value, element) => (value ?? 0) + (element ?? 0))
        .roundNumber(1);
  }
}
