import 'package:flutter/foundation.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../constant/app_common_constants.dart';
import 'food_record_ingredient.dart';
import 'meal_label.dart';

/// Represents a record of food items, including their ingredients, serving sizes, and other properties.
class FoodRecord {
  /// Unique identifier for the food record.
  String id = '';

  String passioID;

  /// Name of the food item.
  String name;

  /// Additional data for the food item.
  String additionalData = '';

  /// Identifier for the food item's icon.
  String iconId = '';

  /// List of ingredients in the food item.
  late List<FoodRecordIngredient> ingredients;

  /// The selected unit for measurement.
  String _selectedUnit = '';

  /// The selected quantity of the food item.
  double _selectedQuantity = zeroQuantity;

  /// List of serving sizes available for the food item.
  late List<PassioServingSize> servingSizes;

  /// List of serving units available for the food item.
  late List<PassioServingUnit> servingUnits;

  PassioIDEntityType? entityType;

  /// Label for the meal type.
  MealLabel? mealLabel;

  // Timestamp for when the food record was created.
  int? _createdAt;

  // License information for open food data.
  String? openFoodLicense;

  // Constant for zero quantity.
  static const zeroQuantity = 0.00001;

  bool isFavorite = false;

  /// Sets the selected unit for the food item while keeping the weight consistent.
  bool setSelectedUnitKeepWeight(String unit) {
    if (_selectedUnit == unit) return true;
    final servingWeight = servingUnits
        .cast<PassioServingUnit?>()
        .firstWhere((element) => element?.unitName == unit, orElse: () => null)
        ?.weight;
    if (servingWeight == null) {
      return false;
    }

    _selectedUnit = unit;
    _selectedQuantity = ingredientWeight() / servingWeight;
    return true;
  }

  /// Private constructor for creating a FoodRecord instance with specified properties.
  FoodRecord._(
    this.id,
    this.passioID,
    this.name,
    this.additionalData,
    this.iconId,
    this.servingSizes,
    this.servingUnits,
    this._selectedQuantity,
    this._selectedUnit,
    this.entityType,
    this.ingredients,
    this._createdAt, {
    this.mealLabel,
    this.openFoodLicense,
  });

  /// Factory constructor to create a FoodRecord from a FoodRecordIngredient instance.
  factory FoodRecord.fromFoodRecordIngredient(FoodRecordIngredient ingredient,
      {PassioIDEntityType entityType = PassioIDEntityType.item}) {
    return FoodRecord._(
      ingredient.id,
      ingredient.passioID,
      ingredient.name,
      '',
      ingredient.iconId,
      ingredient.servingSizes,
      ingredient.servingUnits,
      ingredient.selectedQuantity,
      ingredient.selectedUnit,
      entityType,
      [ingredient],
      null,
      openFoodLicense: ingredient.openFoodLicense,
    );
  }

  /// Factory constructor to create a FoodRecord from a PassioFoodItem instance.
  factory FoodRecord.fromPassioFoodItem(PassioFoodItem foodItem,
      {PassioIDEntityType entityType = PassioIDEntityType.item}) {
    final foodRecord = FoodRecord._(
      '',
      foodItem.id,
      foodItem.name,
      foodItem.details,
      foodItem.iconId,
      foodItem.amount.servingSizes,
      foodItem.amount.servingUnits,
      foodItem.amount.selectedQuantity,
      foodItem.amount.selectedUnit,
      entityType,
      foodItem.ingredients
          .map(FoodRecordIngredient.fromPassioIngredient)
          .toList(),
      null,
      openFoodLicense: foodItem.isOpenFood(),
    );
    foodRecord._calculateQuantityForIngredients();
    foodRecord.logMeal();
    return foodRecord;
  }

  factory FoodRecord.fromJson(Map<String, dynamic> json) => FoodRecord._(
        json['id'] as String,
        json['passioID'] as String,
        json['name'] as String,
        json['additionalData'] as String,
        json['iconId'] as String,
        List<PassioServingSize>.from(
          json['servingSizes']
                  ?.map((dynamic s) => PassioServingSize.fromJson(s)) ??
              [],
        ),
        List<PassioServingUnit>.from(
          json['servingUnits']
                  ?.map((dynamic s) => PassioServingUnit.fromJson(s)) ??
              [],
        ),
        json['selectedQuantity'] as double,
        json['selectedUnit'] as String,
        PassioIDEntityType.values.cast<PassioIDEntityType?>().firstWhere(
              (element) => element?.name == json['entityType'] as String?,
              orElse: () => PassioIDEntityType.item,
            ),
        List<FoodRecordIngredient>.from(
          json['ingredients']
                  ?.map((dynamic s) => FoodRecordIngredient.fromJson(s)) ??
              [],
        ),
        json['createdAt'] as int?,
        mealLabel: json.containsKey('mealLabel')
            ? MealLabel.values.cast<MealLabel?>().firstWhere(
                (element) => element?.value == json['mealLabel'],
                orElse: () => null)
            : null,
        openFoodLicense: json['openFoodLicense'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'passioID': passioID,
        'name': name,
        'additionalData': additionalData,
        'iconId': iconId,
        'ingredients':
            ingredients.map((FoodRecordIngredient s) => s.toJson()).toList(),
        'selectedUnit': _selectedUnit,
        'selectedQuantity': _selectedQuantity,
        'servingSizes':
            servingSizes.map((PassioServingSize s) => s.toJson()).toList(),
        'servingUnits':
            servingUnits.map((PassioServingUnit s) => s.toJson()).toList(),
        'entityType': entityType?.name,
        'createdAt': _createdAt,
        'mealLabel': mealLabel?.value,
        'openFoodLicense': openFoodLicense,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FoodRecord &&
        other.id == id &&
        other.passioID == passioID &&
        other.name == name &&
        other.additionalData == additionalData &&
        other.iconId == iconId &&
        listEquals(ingredients, other.ingredients) &&
        other._selectedUnit == _selectedUnit &&
        other._selectedQuantity == _selectedQuantity &&
        listEquals(servingSizes, other.servingSizes) &&
        listEquals(servingUnits, other.servingUnits) &&
        other.entityType == entityType &&
        other.mealLabel == mealLabel &&
        other._createdAt == _createdAt &&
        other.openFoodLicense == openFoodLicense;
  }

  @override
  int get hashCode => Object.hash(
        id,
        passioID,
        name,
        additionalData,
        iconId,
        ingredients,
        _selectedUnit,
        _selectedQuantity,
        servingSizes,
        servingUnits,
        entityType,
        mealLabel,
        _createdAt,
        openFoodLicense,
      );

  /// Calculates the quantity of ingredients based on the ratio of serving weight to ingredient weight.
  void _calculateQuantityForIngredients() {
    final ratio =
        servingWeight().gramsValue() / ingredientWeight().gramsValue();
    for (var element in ingredients) {
      element.selectedQuantity *= ratio;
    }
  }

  /// Adds an ingredient to the food record at the specified index.
  ///
  /// If the added record contains multiple ingredients, they are added individually to the current list of ingredients.
  void addIngredient(FoodRecord record, {int index = 0}) {
    if (record.ingredients.length == 1) {
      ingredients.insert(index, FoodRecordIngredient.fromFoodRecord(record));
    } else {
      ingredients.insertAll(index, record.ingredients);
    }
    calculateQuantity();
    setSelectedUnitKeepWeight('gram');
    servingSizes = [PassioServingSize(_selectedQuantity, _selectedUnit)];

    // Recipe logic
    if (ingredients.length > 1) {
      entityType = PassioIDEntityType.recipe;
    }
    if (!iconId.startsWith(AppCommonConstants.recipePrefix)) {
      iconId = AppCommonConstants.recipePrefix + iconId;
      name = 'Recipe with $name';
    }
  }

  /// Removes an ingredient from the food record at the specified index.
  ///
  /// Recalculates the quantity of ingredients after removal.
  void removeIngredient(int index) {
    if (index >= ingredients.length) return;

    ingredients.removeAt(index);

    if (ingredients.length == 1 && ingredients.firstOrNull != null) {
      final ingredient = ingredients.firstOrNull;
      if (ingredient != null) {
        name = ingredient.name;
        iconId = ingredient.iconId;
        _selectedUnit = ingredient.selectedUnit;
        _selectedQuantity = ingredient.selectedQuantity;
        servingSizes = ingredient.servingSizes;
        servingUnits = ingredient.servingUnits;
        entityType = ingredient.entityType;
      }
    }

    calculateQuantity();
  }

  /// Replaces an ingredient in the food record with a new ingredient at the specified index.
  ///
  /// Returns true if the replacement was successful, false otherwise.
  bool replaceIngredient(FoodRecord newIngredient, int index) {
    if (index >= ingredients.length) {
      return false;
    }
    ingredients[index] = FoodRecordIngredient.fromFoodRecord(newIngredient);
    calculateQuantity();
    return true;
  }

  /// Calculates the quantity of the food item based on the selected serving unit.
  void calculateQuantity() {
    final weight = ingredientWeight().gramsValue();
    final unitWeight = servingUnits
        .firstWhere((element) => element.unitName == _selectedUnit)
        .weight
        .gramsValue();
    _selectedQuantity = weight / unitWeight;
  }

  /// Calculates the total weight of all ingredients in the food item.
  UnitMass ingredientWeight() {
    return ingredients
        .map((e) => e.servingWeight())
        .reduce((value, element) => (value + element) as UnitMass);
  }

  /// Calculates the serving weight of the food item based on the selected unit.
  UnitMass servingWeight() {
    final unit = servingUnits.cast<PassioServingUnit?>().firstWhere(
        (element) => element?.unitName == _selectedUnit,
        orElse: () => null);
    if (unit == null) {
      return UnitMass(0, UnitMassType.grams);
    }
    return (unit.weight * _selectedQuantity) as UnitMass;
  }

  /// Calculates the nutrients of the food item based on the current serving size.
  PassioNutrients nutrients() {
    final currentWeight = ingredientWeight();
    final ingredientNutrients = ingredients
        .map((ingredient) => (
              ingredient.referenceNutrients,
              ingredient.servingWeight() / currentWeight
            ))
        .toList();
    return PassioNutrients.fromIngredientsData(
        ingredientNutrients, currentWeight);
  }

  /// Retrieves the currently selected unit for measurement.
  String getSelectedUnit() => _selectedUnit;

  /// Sets the selected unit for measurement and recalculates ingredient quantities accordingly.
  ///
  /// Returns true if the unit was successfully set, false otherwise.
  bool setSelectedUnit(String unit) {
    if (_selectedUnit == unit) return true;
    if (servingUnits.cast<PassioServingUnit?>().firstWhere(
            (element) => element?.unitName == unit,
            orElse: () => null) ==
        null) return false;

    _selectedUnit = unit;
    _calculateQuantityForIngredients();
    return true;
  }

  /// Retrieves the currently selected quantity of the food item.
  double getSelectedQuantity() => _selectedQuantity;

  /// Sets the selected quantity for the food item and recalculates ingredient quantities accordingly.
  void setSelectedQuantity(double quantity) {
    if (_selectedQuantity == quantity) return;
    _selectedQuantity = (quantity != 0.0) ? quantity : zeroQuantity;
    _calculateQuantityForIngredients();
  }

  /// Logs the meal with the specified date and time, or defaults to the current date and time if not provided.
  void logMeal({DateTime? dateTime}) {
    dateTime ??= DateTime.now();
    setCreatedAt(dateTime);
    mealLabel = MealLabel.dateToMealLabel(dateTime);
  }

  void setCreatedAt(DateTime dateTime) {
    _createdAt = dateTime.toUtc().millisecondsSinceEpoch;
  }

  DateTime? getCreatedAt() {
    if (_createdAt == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(_createdAt!, isUtc: true)
        .toLocal();
  }

  /// Calculates the nutrients of the food item based on the selected serving size.
  PassioNutrients nutrientsSelectedSize() {
    final currentWeight = servingWeight();

    final ingredientNutrients = ingredients
        .map((e) => (e.referenceNutrients, e.servingWeight() / currentWeight))
        .toList();
    return PassioNutrients.fromIngredientsData(
        ingredientNutrients, currentWeight);
  }

  /// Calculates the nutrients of the food item based on a reference serving size of 100 grams.
  PassioNutrients nutrientsReference() {
    final currentWeight = servingWeight();

    final ingredientNutrients = ingredients
        .map((e) => (e.referenceNutrients, e.servingWeight() / currentWeight))
        .toList();
    return PassioNutrients.fromIngredientsData(
        ingredientNutrients, UnitMass(100, UnitMassType.grams));
  }

  /// OLD STRUCTURE

  /// [computedWeight] is [UnitMass] class and contains weight.
  UnitMass get computedWeight {
    final weight2UnitRatio = servingUnits
        .cast<PassioServingUnit?>()
        .firstWhere((element) => element?.unitName == _selectedUnit,
            orElse: () => null)
        ?.weight
        .value;
    if (weight2UnitRatio != null) {
      return UnitMass(weight2UnitRatio * _selectedQuantity, UnitMassType.grams);
    }
    return UnitMass(0, UnitMassType.grams);
  }
}

/// Extension to calculate the sum of nutritional values for a list of [FoodRecord] objects.
extension FoodRecordListExtension on List<FoodRecord> {
  /// Calculates the sum of calories for all food records in the list.
  double get caloriesSum {
    return fold(
        0,
        (previousValue, foodRecord) =>
            previousValue +
            (foodRecord.nutrientsSelectedSize().calories?.value ?? 0));
  }

  /// Calculates the sum of carbohydrates for all food records in the list.
  double get carbsSum {
    return isNotEmpty
        ? map((foodRecord) =>
                foodRecord.nutrientsSelectedSize().carbs?.value ?? 0.0)
            .reduce((value, element) => value + element)
        : 0;
  }

  /// Calculates the sum of proteins for all food records in the list.
  double get proteinSum {
    return isNotEmpty
        ? map((foodRecord) =>
                foodRecord.nutrientsSelectedSize().proteins?.value ?? 0.0)
            .reduce((value, element) => value + element)
        : 0;
  }

  /// Calculates the sum of fats for all food records in the list.
  double get fatSum {
    return isNotEmpty
        ? map((foodRecord) =>
                foodRecord.nutrientsSelectedSize().fat?.value ?? 0.0)
            .reduce((value, element) => value + element)
        : 0;
  }
}

extension FoodRecordExtension on FoodRecord {
  double get totalAlcohol {
    return nutrientsSelectedSize().alcohol?.value ?? 0;
  }

  double get totalCalcium {
    return nutrientsSelectedSize().calcium?.value ?? 0;
  }

  double get totalCalories {
    return nutrientsSelectedSize().calories?.value ?? 0;
  }

  double get totalCarbs {
    return nutrientsSelectedSize().carbs?.value ?? 0;
  }

  double get totalCholesterol {
    return nutrientsSelectedSize().cholesterol?.value ?? 0;
  }

  double get totalFibers {
    return nutrientsSelectedSize().fibers?.value ?? 0;
  }

  double get totalFat {
    return nutrientsSelectedSize().fat?.value ?? 0;
  }

  double get totalIodine {
    return nutrientsSelectedSize().iodine?.value ?? 0;
  }

  double get totalIron {
    return nutrientsSelectedSize().iron?.value ?? 0;
  }

  double get totalMagnesium {
    return nutrientsSelectedSize().magnesium?.value ?? 0;
  }

  double get totalMonounsaturatedFat {
    return nutrientsSelectedSize().monounsaturatedFat?.value ?? 0;
  }

  double get totalPhosphorus {
    return nutrientsSelectedSize().phosphorus?.value ?? 0;
  }

  double get totalPolyunsaturatedFat {
    return nutrientsSelectedSize().polyunsaturatedFat?.value ?? 0;
  }

  double get totalPotassium {
    return nutrientsSelectedSize().potassium?.value ?? 0;
  }

  double get totalProteins {
    return nutrientsSelectedSize().proteins?.value ?? 0;
  }

  double get totalSatFat {
    return nutrientsSelectedSize().satFat?.value ?? 0;
  }

  double get totalSodium {
    return nutrientsSelectedSize().sodium?.value ?? 0;
  }

  double get totalSugars {
    return nutrientsSelectedSize().sugars?.value ?? 0;
  }

  double get totalSugarsAdded {
    return nutrientsSelectedSize().sugarsAdded?.value ?? 0;
  }

  double get totalSugarsAlcohol {
    return nutrientsSelectedSize().sugarAlcohol?.value ?? 0;
  }

  double get totalTransFat {
    return nutrientsSelectedSize().transFat?.value ?? 0;
  }

  double get totalVitaminA {
    return nutrientsSelectedSize().vitaminA?.value ?? 0;
  }

  double get totalVitaminB6 {
    return nutrientsSelectedSize().vitaminB6?.value ?? 0;
  }

  double get totalVitaminB12 {
    return nutrientsSelectedSize().vitaminB12?.value ?? 0;
  }

  double get totalVitaminB12Added {
    return nutrientsSelectedSize().vitaminB12Added?.value ?? 0;
  }

  double get totalVitaminC {
    return nutrientsSelectedSize().vitaminC?.value ?? 0;
  }

  double get totalVitaminD {
    return nutrientsSelectedSize().vitaminD?.value ?? 0;
  }

  double get totalVitaminE {
    return nutrientsSelectedSize().vitaminE?.value ?? 0;
  }

  double get totalVitaminEAdded {
    return nutrientsSelectedSize().vitaminEAdded?.value ?? 0;
  }

  double get totalZinc {
    return nutrientsSelectedSize().zinc?.value ?? 0;
  }

  double get totalSelenium {
    return nutrientsSelectedSize().selenium?.value ?? 0;
  }

  double get totalFolicAcid {
    return nutrientsSelectedSize().folicAcid?.value ?? 0;
  }

  double get totalChromium {
    return nutrientsSelectedSize().chromium?.value ?? 0;
  }

  double get totalVitaminKPhylloquinone {
    return nutrientsSelectedSize().vitaminKPhylloquinone?.value ?? 0;
  }

  double get totalVitaminKMenaquinone4 {
    return nutrientsSelectedSize().vitaminKMenaquinone4?.value ?? 0;
  }

  double get totalVitaminKDihydrophylloquinone {
    return nutrientsSelectedSize().vitaminKDihydrophylloquinone?.value ?? 0;
  }
}
