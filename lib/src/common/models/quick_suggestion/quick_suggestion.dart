import 'package:nutrition_ai/nutrition_ai.dart';

import '../../util/iterable_extension.dart';
import '../../util/map_extension.dart';
import '../food_record/food_record.dart';
import '../food_record/meal_label.dart';

/// Represents a quick suggestion, which can be either based on a FoodRecord or a PassioFoodDataInfo.
class QuickSuggestion {
  /// The FoodRecord associated with the quick suggestion.
  final FoodRecord? foodRecord;

  /// The PassioFoodDataInfo associated with the quick suggestion.
  final PassioFoodDataInfo? passioFoodDataInfo;

  /// Constructs a QuickSuggestion instance with the provided FoodRecord and PassioFoodDataInfo.
  const QuickSuggestion({
    this.foodRecord,
    this.passioFoodDataInfo,
  });

  /// Converts a list of [FoodRecord]s into a list of unique [QuickSuggestion]s.
  ///
  /// This method groups the food records by name, sorts the groups by their lengths,
  /// and creates quick suggestions for unique records.
  ///
  /// Parameters:
  ///   - foodRecords: A list of food records to process.
  ///
  /// Returns:
  ///   A list of unique quick suggestions based on the input food records.
  static List<QuickSuggestion> fromFoodRecords(
      MealLabel mealLabel, List<FoodRecord> foodRecords) {
    final mealTimeRecords =
        foodRecords.where((element) => element.mealLabel == mealLabel).toList();

    // Group food records by name
    final groupedFoodRecords = mealTimeRecords.groupBy((record) => record.name);

    // Sort the groups by the length of the value list
    final sortedGroupedFoodRecords = groupedFoodRecords
        .sortBy((a, b) => b.value.length.compareTo(a.value.length));

    // Flatten the grouped records into a list
    final flattenedRecords =
        sortedGroupedFoodRecords.values.expand((element) => element).toList();

    // Get unique records based on name
    final uniqueRecords =
        flattenedRecords.distinct(by: (record) => record.name).toList();

    // Create QuickSuggestion objects for unique records
    final quickSuggestions =
        uniqueRecords.map((e) => QuickSuggestion(foodRecord: e)).toList();

    return quickSuggestions;
  }

  /// Converts a list of [PassioFoodDataInfo] into a list of [QuickSuggestion]s.
  ///
  /// This method creates quick suggestions for each PassioFoodDataInfo object in the list.
  ///
  /// Parameters:
  ///   - passioFoodDataInfos: A list of PassioFoodDataInfo objects.
  ///
  /// Returns:
  ///   A list of QuickSuggestion objects based on the input PassioFoodDataInfo objects.
  static List<QuickSuggestion> fromPassioFoodDataInfo(
      List<PassioFoodDataInfo> passionFoodDetails) {
    // Create QuickSuggestion objects for each PassioFoodDataInfo
    final quickSuggestions = passionFoodDetails
        .map((e) => QuickSuggestion(passioFoodDataInfo: e))
        .toList();

    return quickSuggestions;
  }
}
