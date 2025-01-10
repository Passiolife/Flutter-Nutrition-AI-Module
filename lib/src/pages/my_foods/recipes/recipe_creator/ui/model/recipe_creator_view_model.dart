import 'dart:math' as math;

import 'package:flutter/services.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../../../../common/constant/app_images.dart';
import '../../../../../../common/models/food_record/food_record.dart';

class RecipeCreatorViewModel {
  final Uint8List? image;
  final String? recipeName;
  final UnitMass? servingSize;
  final SliderData? sliderData;

  FoodRecord? foodRecord;

  static String get _uniqueId =>
      DateTime.now().millisecondsSinceEpoch.toString();

  static String get _uniqueIconId => '${FoodRecord.userRecipePrefix}$_uniqueId';

  RecipeCreatorViewModel._({
    this.image,
    this.recipeName,
    this.servingSize,
    this.foodRecord,
    this.sliderData = const SliderData(),
  });

  factory RecipeCreatorViewModel.empty() {
    return RecipeCreatorViewModel._();
  }

  static Future<RecipeCreatorViewModel> fromRecord(
      FoodRecord record, Uint8List? image,
      {bool isUpdate = true}) async {
    final foodRecord = FoodRecord.fromJson(record.toJson());

    final sliderData = SliderData().updateSliderData(
      foodRecord.getSelectedUnit(),
      foodRecord.getSelectedQuantity(),
    );

    RecipeCreatorViewModel recipeViewModel = RecipeCreatorViewModel._(
      recipeName: isUpdate ? foodRecord.name : '',
      image: isUpdate ? image : null,
      servingSize: foodRecord.computedWeight,
      sliderData: sliderData,
    );

    recipeViewModel = recipeViewModel.doUpdateIngredients(
      foodRecord: foodRecord,
      isUpdate: false,
    );
    // if (foodRecord.iconId.isNotEmpty) {
      recipeViewModel.foodRecord?.iconId = foodRecord.iconId;
    // }

    return recipeViewModel;
  }

  RecipeCreatorViewModel _copyWith({
    Uint8List? image,
    String? recipeName,
    UnitMass? servingSize,
    FoodRecord? foodRecord,
    SliderData? sliderData,
  }) {
    return RecipeCreatorViewModel._(
      image: image ?? this.image,
      recipeName: recipeName ?? this.recipeName,
      servingSize: servingSize ?? this.servingSize,
      foodRecord: foodRecord ?? this.foodRecord,
      sliderData: sliderData ?? this.sliderData,
    );
  }

  RecipeCreatorViewModel doUpdateImage({Uint8List? image}) {
    return _copyWith(image: image);
  }

  RecipeCreatorViewModel doUpdateRecipeName({String? name}) {
    return _copyWith(recipeName: name);
  }

  RecipeCreatorViewModel doUpdateUnit({String? unit}) {
    if (unit == null) return this;
    foodRecord?.setSelectedServingSize(unit);
    final updatedSliderData = sliderData?.updateSliderData(
        foodRecord!.getSelectedUnit(), foodRecord!.getSelectedQuantity());
    return _copyWith(
      foodRecord: foodRecord,
      sliderData: updatedSliderData,
    );
  }

  RecipeCreatorViewModel doRemoveIngredient(int index) {
    foodRecord = foodRecord?.removeRecipeIngredient(index: index);
    return _copyWith(
      foodRecord: foodRecord,
      servingSize: foodRecord?.computedWeight,
    );
  }

  RecipeCreatorViewModel doUpdateQuantity(
      {double? quantity, required bool fromSlider}) {
    if (quantity == null) this;
    foodRecord?.setSelectedQuantity(quantity!);

    if (!fromSlider) {
      return _copyWith(foodRecord: foodRecord);
    }
    final updatedSliderData = sliderData?.updateSliderData(
        foodRecord!.getSelectedUnit(), foodRecord!.getSelectedQuantity());

    return _copyWith(
      foodRecord: foodRecord,
      servingSize: foodRecord?.computedWeight,
      sliderData: updatedSliderData,
    );
  }

  RecipeCreatorViewModel doUpdateIngredients({
    required FoodRecord foodRecord,
    required bool isUpdate,
    int? index,
  }) {
    if (this.foodRecord == null) {
      this.foodRecord =
          foodRecord.initializeFoodRecord(newIconId: _uniqueIconId);
      // _initializeFoodRecord(foodRecord);
    }
    if (isUpdate) {
      this.foodRecord?.updateRecipeIngredientFromFoodRecord(
          index: index!, foodRecord: foodRecord);
    } else {
      this.foodRecord?.addIngredientsToRecipe(foodRecord: foodRecord);
      /*if (foodRecord.entityType == PassioIDEntityType.recipe) {
        for (var ingredient in foodRecord.ingredients) {
          this.foodRecord?.addRecipeIngredient(ingredient: ingredient);
        }
      } else {
        this
            .foodRecord
            ?.addRecipeIngredientFromFoodRecord(foodRecord: foodRecord);
      }*/
    }
    final updatedSliderData = sliderData?.updateSliderData(
        this.foodRecord!.getSelectedUnit(),
        this.foodRecord!.getSelectedQuantity());
    return _copyWith(
      foodRecord: this.foodRecord,
      servingSize: this.foodRecord?.computedWeight,
      sliderData: updatedSliderData,
    );
  }

  void _initializeFoodRecord(FoodRecord foodRecord) {
    this.foodRecord = FoodRecord.fromJson(foodRecord.toJson());
    this.foodRecord?.updateServingUnits();
    this.foodRecord?.updateServingSizes();
    this.foodRecord?.passioID = '';
    this.foodRecord?.name = '';
    this.foodRecord?.refCode = '';
    this.foodRecord?.entityType = PassioIDEntityType.recipe;
    this.foodRecord?.additionalData = '';
    this.foodRecord?.barcode = null;
    this.foodRecord?.iconId = _uniqueIconId;
    this.foodRecord?.setSelectedQuantity(1);
    this.foodRecord?.setSelectedUnit('serving');
    this.foodRecord?.removeMeal();
    this.foodRecord?.ingredients = [];
  }

  bool get validate =>
      foodRecord != null &&
      (recipeName?.isNotEmpty ?? false) &&
      foodRecord!.ingredients.length >= 2;

  Future<RecipeCreatorViewModel> buildRecipe() async {
    foodRecord?.name = recipeName ?? '';
    foodRecord?.refCode = '';
    foodRecord?.removeMeal();
    if ((foodRecord?.iconIsUserRecipe ?? false) && image == null) {
      final defaultRecipeImage =
          (await rootBundle.load(AppImages.icRecipe)).buffer.asUint8List();
      return _copyWith(image: defaultRecipeImage);
    }
    return this;
  }
}

class SliderData {
  final double minSlider;
  final double maxSlider;
  final int divisions;

  static double get _sliderMultiplier => 5.0;

  static ({String? unit, double value}) _cachedMaxForSlider =
      (unit: null, value: 0);

  const SliderData({
    this.minSlider = FoodRecord.zeroQuantity,
    this.maxSlider = 5,
    this.divisions = 10,
  });

  SliderData updateSliderData(
    String unit,
    double selectedQuantity,
  ) {
    final currentValue = selectedQuantity;

    double maxSlider = _sliderMultiplier;

    if (_cachedMaxForSlider.unit != unit) {
      maxSlider = _sliderMultiplier * math.max(currentValue, 1);
      _cachedMaxForSlider = (
        unit: unit,
        value: maxSlider,
      );
    } else if (_cachedMaxForSlider.value > _sliderMultiplier &&
        _cachedMaxForSlider.value > currentValue) {
      maxSlider = _cachedMaxForSlider.value;
    } else if (_sliderMultiplier > currentValue) {
      maxSlider = _sliderMultiplier;
    } else {
      maxSlider = currentValue;
      _cachedMaxForSlider = (unit: unit, value: currentValue);
    }

    if (maxSlider >= 500) {
      maxSlider = (maxSlider / 10).ceilToDouble() * 10;
    } else {
      maxSlider = maxSlider.ceilToDouble();
    }
    return SliderData(
      minSlider: FoodRecord.zeroQuantity,
      maxSlider: maxSlider,
      divisions: switch (maxSlider) {
        < 10 => (maxSlider / 0.5).round(),
        < 500 => (maxSlider / 1).round(),
        _ => (maxSlider / 10).round(),
      },
    );
  }
}
