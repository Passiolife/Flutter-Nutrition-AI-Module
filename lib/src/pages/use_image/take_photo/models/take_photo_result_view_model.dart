import '../../../../../nutrition_ai_module.dart';
import '../../../../common/util/double_extensions.dart';

class TakePhotoResultViewModel {
  final MealLabel mealLabel;
  final DateTime timestamp;
  final List<FoodRecordViewModel> foodRecords;
  final double calories;
  final double carbs;
  final double protein;
  final double fat;

  bool get isLogEnabled => foodRecords.any((e) => e.isSelected);

  bool get isCreateRecipeEnabled => foodRecords.any((e) => e.isSelected);

  const TakePhotoResultViewModel._({
    required this.mealLabel,
    required this.timestamp,
    this.foodRecords = const [],
    this.calories = 0,
    this.carbs = 0,
    this.protein = 0,
    this.fat = 0,
  });

  factory TakePhotoResultViewModel.init() {
    final timeStamp = DateTime.now().toUtc();
    final mealLabel = MealLabel.dateToMealLabel(timeStamp);
    return TakePhotoResultViewModel._(
      mealLabel: mealLabel,
      timestamp: timeStamp,
    );
  }

  TakePhotoResultViewModel fromFoodRecords(List<FoodRecord> foodRecords) {
    final foodRecordsViewModel = foodRecords
        .expand((e) => [FoodRecordViewModel(foodRecord: e)])
        .toList();
    return copyWith(foodRecords: foodRecordsViewModel).updateMacroNutrients();
  }

  TakePhotoResultViewModel copyWith({
    MealLabel? mealLabel,
    DateTime? timestamp,
    List<FoodRecordViewModel>? foodRecords,
    double? calories,
    double? carbs,
    double? protein,
    double? fat,
  }) {
    return TakePhotoResultViewModel._(
      mealLabel: mealLabel ?? this.mealLabel,
      timestamp: timestamp ?? this.timestamp,
      foodRecords: foodRecords ?? this.foodRecords,
      calories: calories ?? this.calories,
      carbs: carbs ?? this.carbs,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
    );
  }

  TakePhotoResultViewModel updateMealLabel(MealLabel mealLabel) {
    return copyWith(mealLabel: mealLabel);
  }

  TakePhotoResultViewModel updateDateTime(DateTime timestamp) {
    return copyWith(timestamp: timestamp);
  }

  TakePhotoResultViewModel updateIsSelected(int index, bool isSelected) {
    final updatedFoodRecordViewModel =
        foodRecords.elementAt(index).updateIsSelected(isSelected);
    foodRecords[index] = updatedFoodRecordViewModel;
    return copyWith(foodRecords: foodRecords);
  }

  TakePhotoResultViewModel updateFoodRecord(int index, FoodRecord foodRecord) {
    final updatedFoodRecordViewModel =
        foodRecords.elementAt(index).updateFoodRecord(foodRecord);
    foodRecords[index] = updatedFoodRecordViewModel;
    return copyWith(foodRecords: foodRecords);
  }

  TakePhotoResultViewModel updateMacroNutrients() {
    final selectedFoodRecords = foodRecords.where((e) => e.isSelected);

    double calories = 0, carbs = 0, protein = 0, fat = 0;

    for (var element in selectedFoodRecords) {
      calories += element.foodRecord.totalCalories;
      carbs += element.foodRecord.totalCarbs;
      protein += element.foodRecord.totalProteins;
      fat += element.foodRecord.totalFat;
    }
    return copyWith(
        calories: calories, carbs: carbs, protein: protein, fat: fat);
  }
}

// Model to hold the state of each FoodRecord with selection state
class FoodRecordViewModel {
  final FoodRecord foodRecord;
  final bool isSelected;

  String get title => foodRecord.name;

  String get subtitle =>
      '${foodRecord.getSelectedQuantity().format()} ${foodRecord.getSelectedUnit()} (${foodRecord.computedWeight.value.format()} ${foodRecord.computedWeight.symbol})';

  const FoodRecordViewModel({
    required this.foodRecord,
    this.isSelected = true,
  });

  FoodRecordViewModel copyWith({
    FoodRecord? foodRecord,
    bool? isSelected,
  }) {
    return FoodRecordViewModel(
      foodRecord: foodRecord ?? this.foodRecord,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  FoodRecordViewModel updateIsSelected(bool isSelected) {
    return copyWith(isSelected: isSelected);
  }

  FoodRecordViewModel updateFoodRecord(FoodRecord foodRecord) {
    return copyWith(foodRecord: foodRecord);
  }
}
