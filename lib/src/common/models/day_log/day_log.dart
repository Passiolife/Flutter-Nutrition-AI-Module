import '../food_record/food_record_v3.dart';
import '../food_record/meal_label.dart';

class DayLog {
  final DateTime date;
  final List<FoodRecord> records;

  double get consumedCalories {
    return records.caloriesSum;
  }

  double get consumedCarbs {
    return records.carbsSum;
  }

  double get consumedProteins {
    return records.proteinSum;
  }

  double get consumedFat {
    return records.fatSum;
  }

  List<FoodRecord> get breakfastRecords => records
      .where((element) => element.mealLabel == MealLabel.breakfast)
      .toList();

  List<FoodRecord> get lunchRecords =>
      records.where((element) => element.mealLabel == MealLabel.lunch).toList();

  List<FoodRecord> get dinnerRecords => getFoodRecordByMeal(MealLabel.dinner);

  List<FoodRecord> get snackRecords => getFoodRecordByMeal(MealLabel.snack);

  const DayLog({required this.date, this.records = const []});

  void addRecord(FoodRecord record) {
    records.add(record);
  }

  void deleteRecord(FoodRecord record) {
    // records
  }

  List<FoodRecord> getFoodRecordByMeal(MealLabel mealLabel) {
    return records.where((element) => element.mealLabel == mealLabel).toList();
  }
}
