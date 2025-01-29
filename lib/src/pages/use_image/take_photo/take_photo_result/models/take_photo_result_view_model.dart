import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../../../../nutrition_ai_module.dart';
import '../../../../../common/constant/app_colors.dart';
import '../../../../../common/extension/number_extension.dart';
import '../../../../../common/models/daily_nutrition_model.dart';
import '../../../../../common/util/double_extensions.dart';

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
  bool isLogLoading = false;

  bool get isCreateRecipeEnabled => foodRecords.any((e) => e.isSelected);

  TakePhotoResultViewModel._({
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

  TakePhotoResultViewModel fromFoodRecords(
      List<({FoodRecord foodRecord, Uint8List? image, bool isBarcodeNotFound})>
          data) {
    /*final incompleteFoodRecordsViewModel = foodRecords
        .where((e) => !e.hasNutritionFacts)
        .map((e) => FoodRecordViewModel(foodRecord: e))
        .toList();*/
    final foodRecordsViewModel = data
        // .where((e) => e.hasNutritionFacts)
        .map(
          (e) => FoodRecordViewModel(
            foodRecord: e.foodRecord,
            image: e.image,
            isBarcodeNotFound: e.isBarcodeNotFound,
            isSelected: !e.isBarcodeNotFound,
          ),
        )
        .toList();

    return copyWith(
      foodRecords: foodRecordsViewModel,
    ).updateMacroNutrients();
  }

  TakePhotoResultViewModel copyWith({
    MealLabel? mealLabel,
    DateTime? dateTime,
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
      dateTime: dateTime ?? this.dateTime,
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

  TakePhotoResultViewModel updateDateTime(DateTime dateTime) {
    return copyWith(dateTime: dateTime);
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
    double caloriesProgress =
        (calories / caloriesTarget).parseFormatted(places: 2).clamp(0.0, 2.0);
    double caloriesOverProgress =
        math.max(caloriesProgress - 1, 0).parseFormatted(places: 2);
    double caloriesValue =
        caloriesOverProgress > 0 ? caloriesOverProgress : caloriesProgress;
    Color caloriesProgressColor = caloriesOverProgress > 0
        ? AppColors.yellow900Dark
        : AppColors.yellow500;
    Color caloriesBackgroundColor = caloriesOverProgress > 0
        ? AppColors.yellow500
        : AppColors.brandPrimaryLight;

    // Carbs
    double carbsProgress =
        (carbs / carbsTarget).parseFormatted(places: 2).clamp(0.0, 2.0);
    double carbsOverProgress =
        math.max(carbsProgress - 1, 0).parseFormatted(places: 2);
    double carbsValue =
        carbsOverProgress > 0 ? carbsOverProgress : carbsProgress;
    Color carbsProgressColor =
        carbsOverProgress > 0 ? AppColors.lBlue900Dark : AppColors.blue500;
    Color carbsBackgroundColor =
        carbsOverProgress > 0 ? AppColors.blue500 : AppColors.brandPrimaryLight;

    // Protein
    double proteinProgress =
        (protein / proteinTarget).parseFormatted(places: 2).clamp(0.0, 2.0);
    double proteinOverProgress =
        math.max(proteinProgress - 1, 0).parseFormatted(places: 2);
    double proteinValue =
        proteinOverProgress > 0 ? proteinOverProgress : proteinProgress;
    Color proteinProgressColor = proteinOverProgress > 0
        ? AppColors.green900Dark
        : AppColors.green500Normal;
    Color proteinBackgroundColor = proteinOverProgress > 0
        ? AppColors.green500Normal
        : AppColors.brandPrimaryLight;

    // Fat
    double fatProgress =
        (fat / fatTarget).parseFormatted(places: 2).clamp(0.0, 2.0);
    double fatOverProgress =
        math.max(fatProgress - 1, 0).parseFormatted(places: 2);
    double fatValue = fatOverProgress > 0 ? fatOverProgress : fatProgress;
    Color fatProgressColor =
        fatOverProgress > 0 ? AppColors.purple900 : AppColors.purple500;
    Color fatBackgroundColor =
        fatOverProgress > 0 ? AppColors.purple500 : AppColors.brandPrimaryLight;

    final listMacros = [
      DailyNutritionModel(
        footer: 'Calories',
        title: '${calories.round()}',
        subtitle: '${caloriesTarget.round()}',
        value: caloriesValue,
        progressColor: caloriesProgressColor,
        backgroundColor: caloriesBackgroundColor,
      ),
      DailyNutritionModel(
        footer: 'Carbs',
        title: '${carbs.format(places: 1)} g',
        subtitle: '${carbsTarget.format()} g',
        value: carbsValue,
        progressColor: carbsProgressColor,
        backgroundColor: carbsBackgroundColor,
      ),
      DailyNutritionModel(
        footer: 'Protein',
        title: '${protein.format(places: 1)} g',
        subtitle: '${proteinTarget.format()} g',
        value: proteinValue,
        progressColor: proteinProgressColor,
        backgroundColor: proteinBackgroundColor,
      ),
      DailyNutritionModel(
        footer: 'Fat',
        title: '${fat.format(places: 1)} g',
        subtitle: '${fatTarget.format()} g',
        value: fatValue,
        progressColor: fatProgressColor,
        backgroundColor: fatBackgroundColor,
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

  TakePhotoResultViewModel updateMacroNutrientsTarget(
    double caloriesTarget,
    double carbsTarget,
    double proteinTarget,
    double fatTarget,
  ) {
    return copyWith(
      caloriesTarget: caloriesTarget,
      carbsTarget: carbsTarget,
      proteinTarget: proteinTarget,
      fatTarget: fatTarget,
    );
  }

  /// Overrides the hashCode method.
  @override
  int get hashCode {
    return Object.hash(
      mealLabel,
      isLogLoading,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TakePhotoResultViewModel &&
        mealLabel == other.mealLabel &&
        isLogLoading == other.isLogLoading;
  }
}

// Model to hold the state of each FoodRecord with selection state
class FoodRecordViewModel {
  final FoodRecord foodRecord;
  final bool isSelected;
  final Uint8List? image;
  final bool isBarcodeNotFound;

  String get title => foodRecord.name;

  String get subtitle =>
      '${foodRecord.getSelectedQuantity().format()} ${foodRecord.getSelectedUnit()} (${foodRecord.computedWeight.value.format()} ${foodRecord.computedWeight.symbol})';

  const FoodRecordViewModel({
    required this.foodRecord,
    this.isSelected = true,
    this.image,
    this.isBarcodeNotFound = false,
  });

  FoodRecordViewModel copyWith({
    FoodRecord? foodRecord,
    bool? isSelected,
    Uint8List? image,
    bool? isBarcodeNotFound,
  }) {
    return FoodRecordViewModel(
      foodRecord: foodRecord ?? this.foodRecord,
      isSelected: isSelected ?? this.isSelected,
      image: image ?? this.image,
      isBarcodeNotFound: isBarcodeNotFound ?? this.isBarcodeNotFound,
    );
  }

  FoodRecordViewModel updateIsSelected(bool isSelected) {
    return copyWith(isSelected: isSelected);
  }

  FoodRecordViewModel updateFoodRecord(FoodRecord foodRecord) {
    return copyWith(foodRecord: foodRecord);
  }
}
