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
  final bool visibleRecipeCreator;

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
    this.visibleRecipeCreator = false,
  });

  EditFoodPageParams copyWith({
    PassioFoodItem? foodItem,
    FoodRecord? foodRecord,
    FoodRecordIngredient? foodRecordIngredient,
    DetectedCandidate? detectedCandidate,
    PassioFoodDataInfo? passioFoodDataInfo,
    bool? needsReturn,
    bool? isUpdate,
    bool? redirectToDiaryOnLog,
    bool? shouldUpdateServingUnit,
    bool? visibleFoodHeaderView,
    bool? visibleServingSizeView,
    bool? visibleMealTimeView,
    bool? visibleDateView,
    bool? visibleAddIngredient,
    bool? visibleOpenFoodFacts,
    bool? visibleMoreDetails,
    bool? visibleSwitch,
    bool? visibleDelete,
    bool? visibleFavorite,
    bool? visibleFoodCreator,
    bool? visibleLogUponCreate,
    String? title,
    String? positiveButtonText,
    String? iconHeroTag,
    MealLabel? mealLabel,
    String? message,
    String? source,
    bool? visibleRecipeCreator,
  }) {
    return EditFoodPageParams(
      foodItem: foodItem ?? this.foodItem,
      foodRecord: foodRecord ?? this.foodRecord,
      foodRecordIngredient: foodRecordIngredient ?? this.foodRecordIngredient,
      detectedCandidate: detectedCandidate ?? this.detectedCandidate,
      passioFoodDataInfo: passioFoodDataInfo ?? this.passioFoodDataInfo,
      needsReturn: needsReturn ?? this.needsReturn,
      isUpdate: isUpdate ?? this.isUpdate,
      redirectToDiaryOnLog: redirectToDiaryOnLog ?? this.redirectToDiaryOnLog,
      shouldUpdateServingUnit:
          shouldUpdateServingUnit ?? this.shouldUpdateServingUnit,
      visibleFoodHeaderView:
          visibleFoodHeaderView ?? this.visibleFoodHeaderView,
      visibleServingSizeView:
          visibleServingSizeView ?? this.visibleServingSizeView,
      visibleMealTimeView: visibleMealTimeView ?? this.visibleMealTimeView,
      visibleDateView: visibleDateView ?? this.visibleDateView,
      visibleAddIngredient: visibleAddIngredient ?? this.visibleAddIngredient,
      visibleOpenFoodFacts: visibleOpenFoodFacts ?? this.visibleOpenFoodFacts,
      visibleMoreDetails: visibleMoreDetails ?? this.visibleMoreDetails,
      visibleSwitch: visibleSwitch ?? this.visibleSwitch,
      visibleDelete: visibleDelete ?? this.visibleDelete,
      visibleFavorite: visibleFavorite ?? this.visibleFavorite,
      visibleFoodCreator: visibleFoodCreator ?? this.visibleFoodCreator,
      visibleLogUponCreate: visibleLogUponCreate ?? this.visibleLogUponCreate,
      title: title ?? this.title,
      positiveButtonText: positiveButtonText ?? this.positiveButtonText,
      iconHeroTag: iconHeroTag ?? this.iconHeroTag,
      mealLabel: mealLabel ?? this.mealLabel,
      message: message ?? this.message,
      source: source ?? this.source,
      visibleRecipeCreator: visibleRecipeCreator ?? this.visibleRecipeCreator,
    );
  }
}
