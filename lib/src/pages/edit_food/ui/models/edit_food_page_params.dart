part of '../edit_food_page.dart';

class EditFoodPageParams {
  // Data Parameters
  final PassioFoodItem? foodItem;
  final FoodRecord? foodRecord;
  final FoodRecordIngredient? foodRecordIngredient;
  final DetectedCandidate? detectedCandidate;
  final PassioFoodDataInfo? passioFoodDataInfo;

  // Flags for State/Actions
  final bool needsReturn;
  final bool isUpdate;
  final bool redirectToDiaryOnLog;
  final bool shouldUpdateServingUnit;

  // UI Visibility Flags
  final bool visibleFoodHeaderView;
  final bool visibleServingSizeView;
  final bool visibleMealTimeView;
  final bool visibleDateView;
  final bool visibleAddIngredient;
  final bool? visibleOpenFoodFacts;
  final bool visibleMoreDetails;
  final bool visibleSwitch;
  final bool visibleDelete;
  final bool visibleFavorite;
  final bool visibleFoodCreator;
  final bool? visibleLogUponCreate;

  // Miscellaneous
  final String? title;
  final String? positiveButtonText;
  final String? iconHeroTag;
  final MealLabel? mealLabel;
  final String? message;
  final String? source;

  const EditFoodPageParams({
    this.foodItem,
    this.foodRecord,
    this.foodRecordIngredient,
    this.detectedCandidate,
    this.passioFoodDataInfo,
    this.needsReturn = false,
    this.isUpdate = false,
    this.redirectToDiaryOnLog = false,
    this.shouldUpdateServingUnit = false,
    this.visibleFoodHeaderView = true,
    this.visibleServingSizeView = true,
    this.visibleMealTimeView = true,
    this.visibleDateView = true,
    this.visibleAddIngredient = true,
    this.visibleOpenFoodFacts,
    this.visibleMoreDetails = true,
    this.visibleFavorite = true,
    this.visibleSwitch = false,
    this.visibleDelete = false,
    this.visibleFoodCreator = false,
    this.visibleLogUponCreate,
    this.title,
    this.positiveButtonText,
    this.iconHeroTag,
    this.mealLabel,
    this.message,
    this.source,
  });
}