import 'package:json_annotation/json_annotation.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../util/double_extensions.dart';
import '../../util/passio_food_item_data_extension.dart';

part 'food_record.g.dart';

enum MealLabel {
  @JsonValue('Breakfast')
  breakfast('Breakfast'),
  @JsonValue('Lunch')
  lunch('Lunch'),
  @JsonValue('Dinner')
  dinner('Dinner'),
  @JsonValue('Snack')
  snack('Snack');

  const MealLabel(this.value);

  final String value;

  static MealLabel mealLabelBy(DateTime dateTime) {
    return switch ((dateTime.hour * 60) + dateTime.minute) {
      (>= 4 * 60) && (<= (10 * 60) + 30) => MealLabel.breakfast,
      (>= (11 * 60) + 30) && (<= (14 * 60)) => MealLabel.lunch,
      (>= (17 * 60)) && (<= (21 * 60)) => MealLabel.dinner,
      _ => MealLabel.snack,
    };
  }
}

@JsonSerializable(explicitToJson: true)
class FoodRecord {
  FoodRecord({
    this.id,
    this.name,
    this.uuid,
    this.createdAt,
    this.mealLabel,
    this.passioID,
    this.visualPassioID,
    this.visualName,
    this.nutritionalPassioID,
    this.servingSizes,
    this.servingUnits,
    this.scannedUnitName = "scanned amount",
    this.entityType,
    this.selectedUnit,
    this.selectedQuantity = 0,
    this.ingredients,
    this.condiments,
    this.parents,
    this.siblings,
    this.children,
    this.tags,
  });

  /// Factory constructor for creating a FoodRecord from various input parameters.
  ///
  /// It initializes a FoodRecord with values provided in [passioIDAttributes],
  /// [passioFoodItemData], [dateTime], [replaceVisualPassioID], [replaceVisualName],
  /// and [scannedWeight]. Default values are set for certain properties.
  FoodRecord.from({
    PassioIDAttributes? passioIDAttributes,
    PassioFoodItemData? passioFoodItemData,
    DateTime? dateTime,
    PassioID? replaceVisualPassioID,
    String? replaceVisualName,
    double? scannedWeight,
  })  : scannedUnitName = 'scanned amount',
        selectedQuantity = 0,
        tags = [] {
    PassioID passioAttributeId =
        passioIDAttributes?.passioID ?? passioFoodItemData?.passioID ?? '';

    final selectedDateTime = dateTime ?? DateTime.now();

    passioID = passioAttributeId;
    name = passioIDAttributes?.name ?? passioFoodItemData?.name;
    uuid = '';
    entityType =
        passioIDAttributes?.entityType ?? passioFoodItemData?.entityType;
    selectedQuantity = passioIDAttributes?.recipe?.selectedQuantity ??
        passioFoodItemData?.selectedQuantity ??
        0;
    parents = passioIDAttributes?.parents ?? passioFoodItemData?.parents;
    siblings = passioIDAttributes?.siblings ?? passioIDAttributes?.siblings;
    children = passioIDAttributes?.children ?? passioIDAttributes?.children;
    createdAt = selectedDateTime.millisecondsSinceEpoch.toDouble();
    mealLabel = MealLabel.mealLabelBy(selectedDateTime);

    // Below code is for [visualPassioID].
    if (replaceVisualPassioID != null) {
      visualPassioID = replaceVisualPassioID;
    } else {
      visualPassioID = passioID;
    }
    // Below code is for [replaceVisualName]
    if (replaceVisualName != null) {
      visualName = replaceVisualName;
    } else {
      visualName = name;
    }
    if (passioIDAttributes?.entityType == PassioIDEntityType.recipe) {
      final recipe = passioIDAttributes?.recipe;

      ingredients = recipe?.foodItems;
      nutritionalPassioID = recipe?.passioID;
      selectedUnit = recipe?.selectedUnit;
      selectedQuantity = recipe?.selectedQuantity ?? 0;
      servingUnits = recipe?.servingUnits;
      servingSizes = recipe?.servingSizes;
      nutritionalPassioID = recipe?.passioID;
    } else if (passioIDAttributes?.foodItem != null) {
      PassioFoodItemData foodItemData = passioIDAttributes!.foodItem!;

      ingredients = [foodItemData];
      nutritionalPassioID = foodItemData.passioID;
      selectedUnit = foodItemData.selectedUnit;
      selectedQuantity = foodItemData.selectedQuantity;
      servingUnits = foodItemData.servingUnits;
      servingSizes = foodItemData.servingSize;
      // Here, updating the ingredients [PassioID] and Name with food record data.
      ingredients?.asMap().forEach((index, ingredient) {
        ingredients?[index] =
            ingredient.copyWith(passioID: passioID, name: name);
      });
    } else if (passioFoodItemData != null) {
      ingredients = [passioFoodItemData];
      nutritionalPassioID = passioID;
      selectedUnit = passioFoodItemData.selectedUnit;
      selectedQuantity = passioFoodItemData.selectedQuantity;
      servingUnits = passioFoodItemData.servingUnits;
      servingSizes = passioFoodItemData.servingSize;
    } else {
      ingredients = [];
      nutritionalPassioID = passioID;
      selectedUnit = "gram";
      selectedQuantity = 0.0;
      servingUnits = [];
      servingSizes = [];
    }

    if (scannedWeight != null) {
      addScannedWeight(scannedWeight);
    } else {
      setFoodRecordServing(selectedUnit ?? '', selectedQuantity);
    }
  }

  PassioFoodItemData get toFoodItem => PassioFoodItemData(
        passioID ?? '',
        name ?? '',
        tags ?? [],
        selectedQuantity,
        selectedUnit ?? '',
        entityType ?? PassioIDEntityType.item,
        servingUnits ?? [],
        servingSizes ?? [],
        ingredients?.firstOrNull?.ingredientsDescription ?? '',
        ingredients?.firstOrNull?.barcode ?? '',
        ingredients?.firstOrNull?.foodOrigins,
        parents,
        siblings,
        children,
        actualUnitEnergy(
            ingredients!.first, ingredients?.firstOrNull?.totalCalories()),
        actualUnitMass(
            ingredients!.first, ingredients?.firstOrNull?.totalCarbs()),
        actualUnitMass(
            ingredients!.first, ingredients?.firstOrNull?.totalFat()),
        actualUnitMass(
            ingredients!.first, ingredients?.firstOrNull?.totalProteins()),
        actualUnitMass(
            ingredients!.first, ingredients?.firstOrNull?.totalSaturatedFat()),
        actualUnitMass(
            ingredients!.first, ingredients?.firstOrNull?.totalTransFat()),
        actualUnitMass(ingredients!.first,
            ingredients?.firstOrNull?.totalMonounsaturatedFat()),
        actualUnitMass(ingredients!.first,
            ingredients?.firstOrNull?.totalPolyunsaturatedFat()),
        actualUnitMass(
            ingredients!.first, ingredients?.firstOrNull?.totalCholesterol()),
        actualUnitMass(
            ingredients!.first, ingredients?.firstOrNull?.totalSodium()),
        actualUnitMass(
            ingredients!.first, ingredients?.firstOrNull?.totalFibers()),
        actualUnitMass(
            ingredients!.first, ingredients?.firstOrNull?.totalSugars()),
        actualUnitMass(
            ingredients!.first, ingredients?.firstOrNull?.totalSugarsAdded()),
        actualUnitMass(
            ingredients!.first, ingredients?.firstOrNull?.totalVitaminD()),
        actualUnitMass(
            ingredients!.first, ingredients?.firstOrNull?.totalCalcium()),
        actualUnitMass(
            ingredients!.first, ingredients?.firstOrNull?.totalIron()),
        actualUnitMass(
            ingredients!.first, ingredients?.firstOrNull?.totalPotassium()),
        actualUnitIU(
            ingredients!.first, ingredients?.firstOrNull?.totalVitaminA()),
        actualUnitMass(
            ingredients!.first, ingredients?.firstOrNull?.totalVitaminC()),
        actualUnitMass(
            ingredients!.first, ingredients?.firstOrNull?.totalAlcohol()),
        actualUnitMass(
            ingredients!.first, ingredients?.firstOrNull?.totalSugarAlcohol()),
        actualUnitMass(ingredients!.first,
            ingredients?.firstOrNull?.totalVitaminB12Added()),
        actualUnitMass(
            ingredients!.first, ingredients?.firstOrNull?.totalVitaminB12()),
        actualUnitMass(
            ingredients!.first, ingredients?.firstOrNull?.totalVitaminB6()),
        actualUnitMass(
            ingredients!.first, ingredients?.firstOrNull?.totalVitaminE()),
        actualUnitMass(
            ingredients!.first, ingredients?.firstOrNull?.totalVitaminEAdded()),
        actualUnitMass(
            ingredients!.first, ingredients?.firstOrNull?.totalMagnesium()),
        actualUnitMass(
            ingredients!.first, ingredients?.firstOrNull?.totalPhosphorus()),
        actualUnitMass(
            ingredients!.first, ingredients?.firstOrNull?.totalIodine()),
      );

  @JsonKey(includeFromJson: false, includeToJson: false)
  String? id;

  String? name;
  String? uuid;
  double? createdAt;
  MealLabel? mealLabel;
  PassioID? passioID;
  String? visualPassioID;
  String? visualName;
  PassioID? nutritionalPassioID;

  List<PassioServingSize>? servingSizes;
  List<PassioServingUnit>? servingUnits;
  String scannedUnitName;

  List<PassioFoodItemData>? condiments;
  PassioIDEntityType? entityType;
  String? selectedUnit;
  double selectedQuantity;

  List<PassioFoodItemData>? ingredients;

  /// Below is for alternatives.
  List<PassioAlternative>? parents;
  List<PassioAlternative>? siblings;
  List<PassioAlternative>? children;

  final List<String>? tags;

  // JSON deserialization method.
  factory FoodRecord.fromJson(Map<String, dynamic> json) =>
      _$FoodRecordFromJson(json);

  // JSON serialization method.
  Map<String, dynamic> toJson() => _$FoodRecordToJson(this);

  /// Gets the total calories from all ingredients.
  ///
  /// It calculates the sum of total calories for each ingredient and rounds
  /// the result to the nearest whole number.
  double get totalCalories {
    return ingredients
            ?.map((e) => e.totalCalories()?.value)
            .reduce((value, element) => (value ?? 0) + (element ?? 0))
            ?.roundNumber(0) ??
        0;
  }

  /// Gets the total carbohydrates from all ingredients.
  ///
  /// It calculates the sum of total carbohydrates for each ingredient and rounds
  /// the result to one decimal place.
  double get totalCarbs {
    return ingredients
            ?.map((e) => e.totalCarbs()?.value)
            .reduce((value, element) => (value ?? 0) + (element ?? 0))
            ?.roundNumber(1) ??
        0;
  }

  /// Gets the total proteins from all ingredients.
  ///
  /// It calculates the sum of total proteins for each ingredient and rounds
  /// the result to one decimal place.
  double get totalProteins {
    return ingredients
            ?.map((e) => e.totalProteins()?.value)
            .reduce((value, element) => (value ?? 0) + (element ?? 0))
            ?.roundNumber(1) ??
        0;
  }

  /// Gets the total fat from all ingredients.
  ///
  /// It calculates the sum of total fat for each ingredient and rounds
  /// the result to one decimal place.
  double get totalFat {
    return ingredients
            ?.map((e) => e.totalFat()?.value)
            .reduce((value, element) => (value ?? 0) + (element ?? 0))
            .roundNumber(1) ??
        0;
  }

  /// [computedWeight] is [UnitMass] class and contains weight.
  UnitMass get computedWeight {
    final weight2UnitRatio = servingUnits
        ?.cast<PassioServingUnit?>()
        .firstWhere((element) => element?.unitName == selectedUnit,
            orElse: () => null)
        ?.weight
        .value;
    if (weight2UnitRatio != null) {
      return UnitMass(weight2UnitRatio * selectedQuantity, UnitMassType.grams);
    }
    return UnitMass(0, UnitMassType.grams);
  }

  /// Adds a scanned weight to the FoodRecord.
  ///
  /// If the scanned weight is within the valid range (greater than 1 and less than 50000 grams),
  /// a new PassioServingUnit and PassioServingSize are created with the scanned weight and inserted
  /// at the beginning of the servingUnits and servingSizes lists. The food record serving is then updated
  /// based on the scanned unit name and quantity.
  ///
  /// Parameters:
  /// - [scannedWeight]: The weight obtained from scanning.
  void addScannedWeight(double scannedWeight) {
    if (scannedWeight > 1 && scannedWeight < 50000) {
      // Create a PassioServingUnit with the scanned weight.
      final scannedServingUnit = PassioServingUnit(
          scannedUnitName, UnitMass(scannedWeight, UnitMassType.grams));

      // Create a PassioServingSize with a quantity of 1 and the scanned unit name.
      final scannedServingSize = PassioServingSize(1, scannedUnitName);

      // Insert the scanned serving unit at the beginning of the servingUnits list.
      servingUnits?.insert(0, scannedServingUnit);

      // Insert the scanned serving size at the beginning of the servingSizes list.
      servingSizes?.insert(0, scannedServingSize);

      // Update the food record serving based on the scanned unit name and quantity of 1.
      setFoodRecordServing(scannedUnitName, 1);
    } else {
      // Scanned weight is outside the valid range, do nothing.
      return;
    }
  }

  /// Sets the serving for the FoodRecord.
  ///
  /// Checks if the specified unitName exists in the servingUnits list and has a valid weight.
  /// If it does, sets the selectedUnit to the specified unitName, selectedQuantity to the specified quantity,
  /// and then computes the quantity for ingredients using [computeQuantityForIngredients].
  ///
  /// Parameters:
  /// - [unitName]: The name of the serving unit.
  /// - [quantity]: The quantity of the serving unit.
  ///
  /// Returns:
  /// - `true` if the serving was successfully set, `false` otherwise.
  bool setFoodRecordServing(String unitName, double quantity) {
    // Check if the specified unitName exists in the servingUnits list and has a valid weight.
    bool unit = servingUnits
            ?.cast<PassioServingUnit?>()
            .firstWhere((element) => element?.unitName == unitName,
                orElse: () => null)
            ?.weight !=
        null;

    // If the unit does not exist, return false.
    if (!unit) {
      return false;
    }

    // Set the selectedUnit to the specified unitName.
    selectedUnit = unitName;

    // Set the selectedQuantity to the specified quantity.
    selectedQuantity = quantity;

    // Compute the quantity for ingredients.
    computeQuantityForIngredients();

    // Return true, indicating the serving was successfully set.
    return true;
  }

  /// Sets the selected unit for the FoodRecord while keeping the weight constant.
  ///
  /// Finds the weight associated with the specified unitName in the servingUnits list.
  /// If the weight is found, updates the selectedUnit to the specified unitName,
  /// calculates the selectedQuantity based on the computedWeight and weight2Quantity,
  /// and then computes the quantity for ingredients using [computeQuantityForIngredients].
  ///
  /// Parameters:
  /// - [unitName]: The name of the serving unit.
  ///
  /// Returns:
  /// - `true` if the selected unit was successfully set, `false` otherwise.
  bool setSelectedUnitKeepWeight(String unitName) {
    // Find the weight associated with the specified unitName in the servingUnits list.
    final weight2Quantity = servingUnits
        ?.cast<PassioServingUnit?>()
        .firstWhere((element) => element?.unitName == unitName,
            orElse: () => null)
        ?.weight;

    // If the weight is found, update the selectedUnit to the specified unitName.
    if (weight2Quantity != null) {
      // Calculate the selectedQuantity based on the computedWeight and weight2Quantity.
      selectedQuantity = computedWeight.value / weight2Quantity.value;

      // Update the selectedUnit to the specified unitName.
      selectedUnit = unitName;

      // Compute the quantity for ingredients.
      computeQuantityForIngredients();

      // Return true, indicating the selected unit was successfully set.
      return true;
    }

    // If the weight is not found, return false.
    return false;
  }

  /// Computes the quantity for ingredients based on the selected unit and quantity of the FoodRecord.
  ///
  /// Calculates the total weight of all ingredients, then computes a ratio to adjust the
  /// quantity of each ingredient based on the selected unit and quantity of the FoodRecord.
  /// The adjusted quantities are set using [setServingSize], and the updated list of
  /// ingredients is assigned to the [ingredients] property.
  void computeQuantityForIngredients() {
    // Calculate the total weight of all ingredients.
    double totalWeight = ingredients
            ?.map((e) => e.computedWeight().value)
            .reduce((value, element) => value + element) ??
        0;

    // Calculate the ratio to adjust the quantity of each ingredient.
    double ratioMultiply =
        totalWeight > 0 ? computedWeight.value / totalWeight : 0;

    // Create a new list to store the adjusted ingredients.
    List<PassioFoodItemData> newIngredient = [];

    // Iterate through each ingredient, adjust its quantity, and add it to the new list.
    ingredients?.forEach((element) {
      final tempFood = element;

      // Set the serving size for the ingredient based on the selected unit and adjusted quantity.
      element.setServingSize(
          element.selectedUnit, element.selectedQuantity * ratioMultiply);

      // Add the adjusted ingredient to the new list.
      newIngredient.add(tempFood);
    });

    // Update the ingredients list with the adjusted ingredients.
    ingredients = newIngredient;
  }

  /// Adds an ingredient to the list of ingredients for the FoodRecord.
  ///
  /// If there is only one existing ingredient, it updates the [name] property
  /// to indicate that it is a recipe with the added ingredient. The new ingredient
  /// is inserted at the beginning of the list if [isFirst] is true; otherwise, it
  /// is added to the end. The method then computes the quantity for the recipe using
  /// [computeQuantityForRecipe], sets the selected unit to 'gram' and quantity to 1
  /// using [setSelectedUnitKeepWeight], updates the [servingSizes] list, and sets
  /// the [entityType] to [PassioIDEntityType.recipe] if there is more than one ingredient.
  void addIngredients({PassioFoodItemData? ingredient, bool isFirst = false}) {
    // Update the name if there is only one existing ingredient.
    if ((ingredients?.length ?? 0) == 1) {
      name = "Recipe with ${ingredients?.firstOrNull?.name ?? ''}";
    }

    // Add the new ingredient to the list.
    if (ingredient != null) {
      if (isFirst) {
        ingredients?.insert(0, ingredient);
      } else {
        ingredients?.add(ingredient);
      }

      // Compute the quantity for the recipe.
      computeQuantityForRecipe();

      // Set the selected unit to 'gram' and quantity to 1.
      setSelectedUnitKeepWeight('gram');

      // Update the serving sizes list.
      servingSizes = [PassioServingSize(selectedQuantity, selectedUnit ?? '')];

      // Set the entity type to 'recipe' if there is more than one ingredient.
      if ((ingredients?.length ?? 0) > 1) {
        entityType = PassioIDEntityType.recipe;
      }
    }
  }

  /// Replaces an ingredient in the list of ingredients at the specified [atIndex].
  ///
  /// If the [atIndex] is within the bounds of the list, it replaces the existing
  /// ingredient with the [updatedIngredient]. After the replacement, it computes
  /// the quantity for the recipe using [computeQuantityForRecipe].
  ///
  /// Returns true if the replacement is successful, otherwise returns false.
  bool replaceIngredient(PassioFoodItemData updatedIngredient, int atIndex) {
    // Check if the index is within the bounds of the ingredients list.
    if (atIndex < (ingredients?.length ?? 0)) {
      // Replace the ingredient at the specified index.
      ingredients?[atIndex] = updatedIngredient;

      // Recompute the quantity for the recipe.
      computeQuantityForRecipe();

      // Return true indicating successful replacement.
      return true;
    }

    // Return false if the index is out of bounds.
    return false;
  }

  /// Removes an ingredient from the ingredients list at the specified [index].
  ///
  /// If the [index] is within the bounds of the ingredients list, the ingredient
  /// is removed. If, after removal, there is only one ingredient remaining,
  /// the food record's properties are updated with the details of the remaining
  /// ingredient. It then recomputes the quantity for the recipe and returns true.
  /// If the [index] is out of bounds, it returns false.
  bool removeIngredient(int index) {
    // Check if the index is within the bounds of the ingredients list.
    if (index > (ingredients?.length ?? 0)) {
      return false;
    }

    // Remove the ingredient at the specified index.
    ingredients?.removeAt(index);

    // If there is only one ingredient remaining, update the food record properties.
    if (ingredients?.length == 1) {
      final ingredient = ingredients?.first;
      passioID = ingredient?.passioID;
      name = ingredient?.name;
      selectedUnit = ingredient?.selectedUnit;
      selectedQuantity = ingredient?.selectedQuantity ?? 1;
      servingSizes = ingredient?.servingSize;
      servingUnits = ingredient?.servingUnits;
      entityType = ingredient?.entityType;
    }

    // Recompute the quantity for the recipe.
    computeQuantityForRecipe();

    // Return true, indicating successful removal.
    return true;
  }

  /// Computes the quantity for the recipe based on the total weight of ingredients
  /// and the selected serving unit.
  ///
  /// It calculates the total weight of all ingredients and then determines the
  /// selected quantity by dividing the total weight by the weight of the selected
  /// serving unit. The result is stored in the [selectedQuantity] property.
  void computeQuantityForRecipe() {
    // Calculate the total weight of all ingredients.
    final totalWeight = ingredients
        ?.map((e) => e.computedWeight().value)
        .reduce((value, element) => value + element);

    // Find the selected serving unit from the serving units list.
    final servingUnit = servingUnits?.cast<PassioServingUnit?>().firstWhere(
        (element) => element?.unitName == selectedUnit,
        orElse: () => null);

    // If a serving unit is found, calculate the selected quantity.
    if (servingUnit != null) {
      selectedQuantity = (totalWeight ?? 1) / servingUnit.weight.value;
    }
  }
}
