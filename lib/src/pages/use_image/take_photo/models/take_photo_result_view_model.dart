import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../../nutrition_ai_module.dart';
import '../../../../common/constant/app_colors.dart';
import '../../../../common/models/daily_nutrition_model.dart';
import '../../../../common/util/double_extensions.dart';

class TakePhotoResultViewModel {
  final MealLabel mealLabel;
  final DateTime dateTime;
  final List<FoodRecordViewModel> foodRecords;
  final double calories;
  final double caloriesTarget;
  final double carbs;
  final double carbsTarget;
  final double protein;
  final double proteinTarget;
  final double fat;
  final double fatTarget;
  final List<DailyNutritionModel> listMacros;

  bool get isLogEnabled => foodRecords.any((e) => e.isSelected);

  bool get isCreateRecipeEnabled => foodRecords.any((e) => e.isSelected);

  const TakePhotoResultViewModel._({
    required this.mealLabel,
    required this.dateTime,
    this.foodRecords = const [],
    this.calories = 0,
    this.caloriesTarget = 0,
    this.carbs = 0,
    this.carbsTarget = 0,
    this.protein = 0,
    this.proteinTarget = 0,
    this.fat = 0,
    this.fatTarget = 0,
    this.listMacros = const [],
  });

  factory TakePhotoResultViewModel.init() {
    final timeStamp = DateTime.now().toUtc();
    final mealLabel = MealLabel.dateToMealLabel(timeStamp);
    return TakePhotoResultViewModel._(
      mealLabel: mealLabel,
      dateTime: timeStamp,
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
    double? caloriesTarget,
    double? carbs,
    double? carbsTarget,
    double? protein,
    double? proteinTarget,
    double? fat,
    double? fatTarget,
    List<DailyNutritionModel>? listMacros,
  }) {
    return TakePhotoResultViewModel._(
      mealLabel: mealLabel ?? this.mealLabel,
      dateTime: timestamp ?? this.dateTime,
      foodRecords: foodRecords ?? this.foodRecords,
      calories: calories ?? this.calories,
      caloriesTarget: caloriesTarget ?? this.caloriesTarget,
      carbs: carbs ?? this.carbs,
      carbsTarget: carbsTarget ?? this.carbsTarget,
      protein: protein ?? this.protein,
      proteinTarget: proteinTarget ?? this.proteinTarget,
      fat: fat ?? this.fat,
      fatTarget: fatTarget ?? this.fatTarget,
      listMacros: listMacros ?? this.listMacros,
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

    // Calories
    double caloriesProgress = (calories / caloriesTarget).clamp(0.0, 2.0);
    // Determine over progress
    double caloriesOverProgress = math.max(caloriesProgress - 1, 0);
    // Set the calories value, ensuring it's non-negative
    double caloriesValue =
        caloriesOverProgress > 0 ? caloriesOverProgress : caloriesProgress;
    // Determine progress color based on over progress
    Color caloriesProgressColor = caloriesOverProgress > 0
        ? AppColors.yellow500
        : AppColors.yellow900Dark;
    // Set background color based on over progress
    Color caloriesBackgroundColor = caloriesOverProgress > 0
        ? AppColors.yellow500
        : AppColors.brandPrimaryLight;

    // Carbs
    double carbsProgress = (carbs / carbsTarget).clamp(0.0, 2.0);
    // Determine over progress
    double carbsOverProgress = math.max(carbsProgress - 1, 0);
    // Set the calories value, ensuring it's non-negative
    double caloriesValue =
    caloriesOverProgress > 0 ? caloriesOverProgress : caloriesProgress;
    // Determine progress color based on over progress
    Color caloriesProgressColor = caloriesOverProgress > 0
        ? AppColors.yellow500
        : AppColors.yellow900Dark;
    // Set background color based on over progress
    Color caloriesBackgroundColor = caloriesOverProgress > 0
        ? AppColors.yellow500
        : AppColors.brandPrimaryLight;

    final listMacros = [
      DailyNutritionModel(
        footer: 'Calories',
        title: '$calories',
        subtitle: '$caloriesTarget',
        value: caloriesValue,
        progressColor: caloriesProgressColor,
        backgroundColor: caloriesBackgroundColor,
      ),
      DailyNutritionModel(
        footer: 'Carbs',
        title: '${carbs.format(places: 1)} g',
        subtitle: '${carbsTarget.format()} g',
        value: caloriesValue,
        progressColor: caloriesProgressColor,
        backgroundColor: caloriesBackgroundColor,
      ),
    ];

    return copyWith(
      calories: calories,
      carbs: carbs,
      protein: protein,
      fat: fat,
      listMacros: listMacros,
    );
  }

  TakePhotoResultViewModel updateMacroNutrientsTarget(double caloriesTarget,
      double carbsTarget, double proteinTarget, double fatTarget) {
    return copyWith(
      caloriesTarget: caloriesTarget,
      carbsTarget: carbsTarget,
      proteinTarget: proteinTarget,
      fatTarget: fatTarget,
    );
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
