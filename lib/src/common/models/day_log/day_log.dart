import '../food_record/food_record.dart';
import '../food_record/meal_label.dart';

/// A model class representing a day's log, including food records.
class DayLog {
  /// The date of the day log.
  final DateTime date;

  /// The list of food records for the day.
  final List<FoodRecord> records;

  /// Constructs a [DayLog] with the specified [date] and [records].
  const DayLog({required this.date, this.records = const []});

  /// Calculates the total consumed calories from the records.
  double get consumedCalories {
    return records.caloriesSum;
  }

  /// Calculates the total consumed carbs from the records.
  double get consumedCarbs {
    return records.carbsSum;
  }

  /// Calculates the total consumed proteins from the records.
  double get consumedProteins {
    return records.proteinSum;
  }

  /// Calculates the total consumed fat from the records.
  double get consumedFat {
    return records.fatSum;
  }

  /// Retrieves all food records categorized as breakfast.
  List<FoodRecord> get breakfastRecords => records
      .where((element) => element.mealLabel == MealLabel.breakfast)
      .toList();

  /// Retrieves all food records categorized as lunch.
  List<FoodRecord> get lunchRecords =>
      records.where((element) => element.mealLabel == MealLabel.lunch).toList();

  /// Retrieves all food records categorized as dinner.
  List<FoodRecord> get dinnerRecords => getFoodRecordByMeal(MealLabel.dinner);

  /// Retrieves all food records categorized as snack.
  List<FoodRecord> get snackRecords => getFoodRecordByMeal(MealLabel.snack);

  /// Adds a [record] to the day log.
  void addRecord(FoodRecord record) {
    records.add(record);
  }

  /// Deletes a [record] from the day log.
  void deleteRecord(FoodRecord record) {
    records.remove(record);
    // records
  }

  /// Retrieves food records categorized by the provided [mealLabel].
  List<FoodRecord> getFoodRecordByMeal(MealLabel mealLabel) {
    return records.where((element) => element.mealLabel == mealLabel).toList();
  }
}
