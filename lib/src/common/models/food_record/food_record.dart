import 'package:json_annotation/json_annotation.dart';

// part 'food_record.g.dart';

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

/*@JsonSerializable(converters: [
  PassioServingUnitConverter(),
  PassioServingSizeConverter(),
  PassioAlternativeConverter(),
  PassioFoodOriginConverter(),
  PassioFoodItemDataConverter(),
  UnitEnergyConverter(),
  UnitMassConverter(),
  UnitIUConverter(),
])*/
class FoodRecord {
  /*FoodRecord({
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
  });*/

  /*FoodRecord.from({
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

  factory FoodRecord.fromJson(dynamic json) =>
      _$FoodRecordFromJson(Map<String, dynamic>.from(json));

  Map<String, dynamic> toJson() => _$FoodRecordToJson(this);

  /// Methods for the Food Record class.
  double get totalCalories {
    return ingredients
            ?.map((e) => e.totalCalories()?.value)
            .reduce((value, element) => (value ?? 0) + (element ?? 0))
            ?.roundNumber(0) ??
        0;
  }

  double get totalCarbs {
    return ingredients
            ?.map((e) => e.totalCarbs()?.value)
            .reduce((value, element) => (value ?? 0) + (element ?? 0))
            ?.roundNumber(1) ??
        0;
  }

  double get totalProteins {
    return ingredients
            ?.map((e) => e.totalProteins()?.value)
            .reduce((value, element) => (value ?? 0) + (element ?? 0))
            ?.roundNumber(1) ??
        0;
  }

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

  void addScannedWeight(double scannedWeight) {
    if (scannedWeight > 1 && scannedWeight < 50000) {
      final scannedServingUnit = PassioServingUnit(
          scannedUnitName, UnitMass(scannedWeight, UnitMassType.grams));
      final scannedServingSize = PassioServingSize(1, scannedUnitName);
      servingUnits?.insert(0, scannedServingUnit);
      servingSizes?.insert(0, scannedServingSize);
      setFoodRecordServing(scannedUnitName, 1);
    } else {
      return;
    }
  }

  bool setFoodRecordServing(String unitName, double quantity) {
    bool unit = servingUnits
            ?.cast<PassioServingUnit?>()
            .firstWhere((element) => element?.unitName == unitName,
                orElse: () => null)
            ?.weight !=
        null;
    if (!unit) {
      return false;
    }
    selectedUnit = unitName;
    selectedQuantity = quantity;
    computeQuantityForIngredients();
    return true;
  }

  bool setSelectedUnitKeepWeight(String unitName) {
    final weight2Quantity = servingUnits
        ?.cast<PassioServingUnit?>()
        .firstWhere((element) => element?.unitName == unitName,
            orElse: () => null)
        ?.weight;
    if (weight2Quantity != null) {
      selectedQuantity = computedWeight.value / weight2Quantity.value;
      selectedUnit = unitName;
      computeQuantityForIngredients();
      return true;
    }
    return false;
  }

  void computeQuantityForIngredients() {
    double totalWeight = ingredients
            ?.map((e) => e.computedWeight().value)
            .reduce((value, element) => value + element) ??
        0;
    double ratioMultiply = 0;
    if (totalWeight > 0) {
      ratioMultiply = computedWeight.value / totalWeight;
    }

    List<PassioFoodItemData> newIngredient = [];
    ingredients?.forEach((element) {
      final tempFood = element;
      element.setServingSize(
          element.selectedUnit, element.selectedQuantity * ratioMultiply);
      newIngredient.add(tempFood);
    });
    ingredients = newIngredient;
  }

  void addIngredients({PassioFoodItemData? ingredient, bool isFirst = false}) {
    if ((ingredients?.length ?? 0) == 1) {
      name = "Recipe with ${ingredients?.firstOrNull?.name ?? ''}";
    }
    if (ingredient != null) {
      if (isFirst) {
        ingredients?.insert(0, ingredient);
      } else {
        ingredients?.add(ingredient);
      }
      computeQuantityForRecipe();
      setSelectedUnitKeepWeight('gram');
      servingSizes = [PassioServingSize(selectedQuantity, selectedUnit ?? '')];
      if ((ingredients?.length ?? 0) > 1) {
        entityType = PassioIDEntityType.recipe;
      }
    }
  }

  bool replaceIngredient(PassioFoodItemData updatedIngredient, int atIndex) {
    if (atIndex < (ingredients?.length ?? 0)) {
      ingredients?[atIndex] = updatedIngredient;
      computeQuantityForRecipe();
      return true;
    }
    return false;
  }

  bool removeIngredient(int index) {
    if (index > (ingredients?.length ?? 0)) {
      return false;
    }
    ingredients?.removeAt(index);
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
    computeQuantityForRecipe();
    return true;
  }

  void computeQuantityForRecipe() {
    final totalWeight = ingredients
        ?.map((e) => e.computedWeight().value)
        .reduce((value, element) => value + element);
    final servingUnit = servingUnits?.cast<PassioServingUnit?>().firstWhere(
        (element) => element?.unitName == selectedUnit,
        orElse: () => null);
    if (servingUnit != null) {
      selectedQuantity = (totalWeight ?? 1) / servingUnit.weight.value;
    }
  }*/
}

/// Converters:

/// [PassioServingUnitsConverter]
/*class PassioServingUnitConverter
    extends JsonConverter<PassioServingUnit, dynamic> {
  const PassioServingUnitConverter();

  @override
  PassioServingUnit fromJson(dynamic json) {
    /// Parsing the json response.
    final jsonData = Map<String, dynamic>.from(json);

    String unitName = '';
    UnitMass unitMass;

    // Parse the [unitName] from [jsonData].
    if (jsonData.containsKey('unitName')) {
      unitName = jsonData['unitName'];
    }

    // Parse the [weight] from [jsonData].
    if (jsonData.containsKey('weight')) {
      unitMass = const UnitMassConverter().fromJson(jsonData['weight']) ??
          UnitMass(0, UnitMassType.values.first);
    } else {
      unitMass = UnitMass(0, UnitMassType.values.first);
    }
    return PassioServingUnit(unitName, unitMass);
  }

  @override
  Map<String, dynamic>? toJson(PassioServingUnit object) {
    return {
      'unitName': object.unitName,
      'weight': {
        'value': object.weight.value,
        'unit': {
          'converter': {
            'constant': '0', // TODO: Pending need to discuss with marin
            'coefficient': object.weight.unit.converter,
          },
          'symbol': object.weight.unit.symbol,
        }
      },
    };
  }
}

/// [PassioServingUnitsConverter]
class PassioServingSizeConverter
    extends JsonConverter<PassioServingSize, dynamic> {
  const PassioServingSizeConverter();

  @override
  PassioServingSize fromJson(dynamic json) {
    /// Parsing the json response.
    final jsonData = Map<String, dynamic>.from(json);

    double quantity = 0;
    String unitName = '';

    // Parse the [quantity] from [jsonData].
    if (jsonData.containsKey('quantity')) {
      quantity = double.tryParse(jsonData['quantity'].toString()) ?? 0;
    }

    // Parse the [unitName] from [jsonData].
    if (jsonData.containsKey('unitName')) {
      unitName = jsonData['unitName'];
    }
    return PassioServingSize(quantity, unitName);
  }

  @override
  Map<String, dynamic>? toJson(PassioServingSize object) {
    return {
      'quantity': object.quantity,
      'unitName': object.unitName,
    };
  }
}

/// [PassioAlternativeConverter]
class PassioAlternativeConverter
    extends JsonConverter<PassioAlternative, dynamic> {
  const PassioAlternativeConverter();

  @override
  PassioAlternative fromJson(dynamic json) {
    /// Parsing the json response.
    final jsonData = Map<String, dynamic>.from(json);

    PassioID passioID = '';
    String name = '';
    double? quantity;
    String? unitName;

    // Parse the [passioID] from [jsonData].
    if (jsonData.containsKey('passioID')) {
      passioID = jsonData['passioID'];
    }

    // Parse the [name] from [jsonData].
    if (jsonData.containsKey('name')) {
      name = jsonData['name'];
    }

    // Parse the [quantity] from [jsonData].
    if (jsonData.containsKey('quantity')) {
      quantity = double.tryParse(jsonData['quantity'].toString()) ?? 0;
    }

    // Parse the [unitName] from [jsonData].
    if (jsonData.containsKey('unitName')) {
      unitName = jsonData['unitName'];
    }

    return PassioAlternative(passioID, name, quantity, unitName);
  }

  @override
  Map<String, dynamic>? toJson(PassioAlternative object) {
    return {
      'passioID': object.passioID,
      'name': object.name,
      'quantity': object.quantity,
      'unitName': object.unitName,
    };
  }
}

/// [PassioFoodOriginConverter]
class PassioFoodOriginConverter
    extends JsonConverter<PassioFoodOrigin, dynamic> {
  const PassioFoodOriginConverter();

  @override
  PassioFoodOrigin fromJson(dynamic json) {
    /// Parsing the json response.
    final jsonData = Map<String, dynamic>.from(json);

    String id = '';
    String source = '';
    String? licenseCopy;

    // Parse the [id] from [jsonData].
    if (jsonData.containsKey('id')) {
      id = jsonData['id'];
    }

    // Parse the [source] from [jsonData].
    if (jsonData.containsKey('source')) {
      source = jsonData['source'];
    }

    // Parse the [licenseCopy] from [jsonData].
    if (jsonData.containsKey('licenseCopy')) {
      licenseCopy = jsonData['licenseCopy'];
    }

    return PassioFoodOrigin(id, source, licenseCopy);
  }

  @override
  Map<String, dynamic>? toJson(PassioFoodOrigin object) {
    return {
      'id': object.id,
      'source': object.source,
      'licenseCopy': object.licenseCopy,
    };
  }
}

/// [PassioFoodItemDataConverter]
class PassioFoodItemDataConverter
    extends JsonConverter<PassioFoodItemData, dynamic> {
  const PassioFoodItemDataConverter();

  @override
  PassioFoodItemData fromJson(dynamic json) {
    /// Parsing the json response.
    final jsonData = Map<String, dynamic>.from(json);

    PassioID passioId =
        jsonData.containsKey('passioID') ? jsonData['passioID'] : '';
    String name = jsonData.containsKey('name') ? jsonData['name'] : '';
    List<String>? tags = jsonData.containsKey('tags')
        ? List<String>.from(jsonData['tags'] ?? [])
        : <String>[];
    double selectedQuantity = jsonData.containsKey('selectedQuantity')
        ? double.parse(jsonData['selectedQuantity'].toString())
        : double.parse('0');
    String selectedUnit =
        jsonData.containsKey('selectedUnit') ? jsonData['selectedUnit'] : '';

    String? ingredientsDescription =
        jsonData.containsKey('ingredientsDescription')
            ? jsonData['ingredientsDescription']
            : '';
    Barcode? barcode =
        jsonData.containsKey('barcode') ? jsonData['barcode'] : null;

    PassioIDEntityType entityType = jsonData.containsKey('entityType')
        ? PassioIDEntityType.values.firstWhere(
            (element) => element.name == jsonData['entityType'],
            orElse: () => PassioIDEntityType.item)
        : PassioIDEntityType.item;

    /// [servingUnits]
    List<PassioServingUnit> servingUnits =
        (jsonData['servingUnits'] as List<dynamic>?)
                ?.map<PassioServingUnit>(
                    const PassioServingUnitConverter().fromJson)
                .toList() ??
            [];

    /// [servingSize]
    List<PassioServingSize> servingSize =
        (jsonData['servingSize'] as List<dynamic>?)
                ?.map<PassioServingSize>(
                    const PassioServingSizeConverter().fromJson)
                .toList() ??
            [];

    /// [foodOriginsData]
    List<PassioFoodOrigin> foodOrigins =
        (jsonData['foodOrigins'] as List<dynamic>?)
                ?.map(const PassioFoodOriginConverter().fromJson)
                .toList() ??
            [];

    /// [parentsData]
    List<PassioAlternative> parents = (jsonData['parents'] as List<dynamic>?)
            ?.map(const PassioAlternativeConverter().fromJson)
            .toList() ??
        [];

    /// [siblings]
    List<PassioAlternative> siblings = (jsonData['siblings'] as List<dynamic>?)
            ?.map(const PassioAlternativeConverter().fromJson)
            .toList() ??
        [];

    /// [children]
    List<PassioAlternative> children = (jsonData['children'] as List<dynamic>?)
            ?.map(const PassioAlternativeConverter().fromJson)
            .toList() ??
        [];

    UnitEnergy? calories = jsonData.containsKey('calories')
        ? const UnitEnergyConverter().fromJson(jsonData['calories'])
        : null;
    UnitMass? carbs = jsonData.containsKey('carbs')
        ? const UnitMassConverter().fromJson(jsonData['carbs'])
        : null;
    UnitMass? fat = jsonData.containsKey('fat')
        ? const UnitMassConverter().fromJson(jsonData['fat'])
        : null;
    UnitMass? proteins = jsonData.containsKey('proteins')
        ? const UnitMassConverter().fromJson(jsonData['proteins'])
        : null;
    UnitMass? saturatedFat = jsonData.containsKey('saturatedFat')
        ? const UnitMassConverter().fromJson(jsonData['saturatedFat'])
        : null;
    UnitMass? transFat = jsonData.containsKey('transFat')
        ? const UnitMassConverter().fromJson(jsonData['transFat'])
        : null;
    UnitMass? monounsaturatedFat = jsonData.containsKey('monounsaturatedFat')
        ? const UnitMassConverter().fromJson(jsonData['monounsaturatedFat'])
        : null;
    UnitMass? polyunsaturatedFat = jsonData.containsKey('polyunsaturatedFat')
        ? const UnitMassConverter().fromJson(jsonData['polyunsaturatedFat'])
        : null;
    UnitMass? cholesterol = jsonData.containsKey('cholesterol')
        ? const UnitMassConverter().fromJson(jsonData['cholesterol'])
        : null;
    UnitMass? sodium = jsonData.containsKey('sodium')
        ? const UnitMassConverter().fromJson(jsonData['sodium'])
        : null;
    UnitMass? fibers = jsonData.containsKey('fibers')
        ? const UnitMassConverter().fromJson(jsonData['fibers'])
        : null;
    UnitMass? sugars = jsonData.containsKey('sugars')
        ? const UnitMassConverter().fromJson(jsonData['sugars'])
        : null;
    UnitMass? sugarsAdded = jsonData.containsKey('sugarsAdded')
        ? const UnitMassConverter().fromJson(jsonData['sugarsAdded'])
        : null;
    UnitMass? vitaminD = jsonData.containsKey('vitaminD')
        ? const UnitMassConverter().fromJson(jsonData['vitaminD'])
        : null;
    UnitMass? calcium = jsonData.containsKey('calcium')
        ? const UnitMassConverter().fromJson(jsonData['calcium'])
        : null;
    UnitMass? iron = jsonData.containsKey('iron')
        ? const UnitMassConverter().fromJson(jsonData['iron'])
        : null;
    UnitMass? potassium = jsonData.containsKey('potassium')
        ? const UnitMassConverter().fromJson(jsonData['potassium'])
        : null;
    UnitIU? vitaminA = jsonData.containsKey('vitaminA')
        ? const UnitIUConverter().fromJson(jsonData['vitaminA'])
        : null;
    UnitMass? vitaminC = jsonData.containsKey('vitaminC')
        ? const UnitMassConverter().fromJson(jsonData['vitaminC'])
        : null;
    UnitMass? alcohol = jsonData.containsKey('alcohol')
        ? const UnitMassConverter().fromJson(jsonData['alcohol'])
        : null;
    UnitMass? sugarAlcohol = jsonData.containsKey('sugarAlcohol')
        ? const UnitMassConverter().fromJson(jsonData['sugarAlcohol'])
        : null;
    UnitMass? vitaminB12Added = jsonData.containsKey('vitaminB12Added')
        ? const UnitMassConverter().fromJson(jsonData['vitaminB12Added'])
        : null;
    UnitMass? vitaminB12 = jsonData.containsKey('vitaminB12')
        ? const UnitMassConverter().fromJson(jsonData['vitaminB12'])
        : null;
    UnitMass? vitaminB6 = jsonData.containsKey('vitaminB6')
        ? const UnitMassConverter().fromJson(jsonData['vitaminB6'])
        : null;
    UnitMass? vitaminE = jsonData.containsKey('vitaminE')
        ? const UnitMassConverter().fromJson(jsonData['vitaminE'])
        : null;
    UnitMass? vitaminEAdded = jsonData.containsKey('vitaminEAdded')
        ? const UnitMassConverter().fromJson(jsonData['vitaminEAdded'])
        : null;
    UnitMass? magnesium = jsonData.containsKey('magnesium')
        ? const UnitMassConverter().fromJson(jsonData['magnesium'])
        : null;
    UnitMass? phosphorus = jsonData.containsKey('phosphorus')
        ? const UnitMassConverter().fromJson(jsonData['phosphorus'])
        : null;
    UnitMass? iodine = jsonData.containsKey('iodine')
        ? const UnitMassConverter().fromJson(jsonData['iodine'])
        : null;

    return PassioFoodItemData(
      passioId,
      name,
      tags,
      selectedQuantity,
      selectedUnit,
      entityType,
      servingUnits,
      servingSize,
      ingredientsDescription,
      barcode,
      foodOrigins,
      parents,
      siblings,
      children,
      calories,
      carbs,
      fat,
      proteins,
      saturatedFat,
      transFat,
      monounsaturatedFat,
      polyunsaturatedFat,
      cholesterol,
      sodium,
      fibers,
      sugars,
      sugarsAdded,
      vitaminD,
      calcium,
      iron,
      potassium,
      vitaminA,
      vitaminC,
      alcohol,
      sugarAlcohol,
      vitaminB12Added,
      vitaminB12,
      vitaminB6,
      vitaminE,
      vitaminEAdded,
      magnesium,
      phosphorus,
      iodine,
    );
  }

  UnitEnergy? actualUnitEnergy(
      PassioFoodItemData foodItemData, UnitEnergy? unitEnergy) {
    if (unitEnergy != null) {
      double actualUnitEnergy = (unitEnergy.value) /
          (foodItemData.computedWeight().gramsValue() / 100);
      return UnitEnergy(actualUnitEnergy, unitEnergy.unit);
    }
    return unitEnergy;
  }

  UnitMass? actualUnitMass(
      PassioFoodItemData foodItemData, UnitMass? unitMass) {
    if (unitMass != null) {
      double actualUnitMass =
          (unitMass.value) / (foodItemData.computedWeight().gramsValue() / 100);
      return UnitMass(actualUnitMass, unitMass.unit);
    }
    return null;
  }

  UnitIU? actualUnitIU(PassioFoodItemData foodItemData, UnitIU? unitIU) {
    if (unitIU != null) {
      double actualUnitMass =
          (unitIU.value) / (foodItemData.computedWeight().gramsValue() / 100);
      return UnitIU(actualUnitMass);
    }
    return null;
  }

  @override
  Map<String, dynamic>? toJson(PassioFoodItemData object) {
    return {
      'passioID': object.passioID,
      'name': object.name,
      'tags': object.tags,
      'selectedQuantity': object.selectedQuantity,
      'selectedUnit': object.selectedUnit,
      'entityType': object.entityType.name,
      'servingUnits': object.servingUnits
          .map((e) => const PassioServingUnitConverter().toJson(e))
          .toList(),
      'servingSize': object.servingSize
          .map((e) => const PassioServingSizeConverter().toJson(e))
          .toList(),
      'ingredientsDescription': object.ingredientsDescription,
      'barcode': object.barcode,
      'foodOrigins': object.foodOrigins
          ?.map((e) => const PassioFoodOriginConverter().toJson(e))
          .toList(),
      'parents': object.parents
          ?.map((e) => const PassioAlternativeConverter().toJson(e))
          .toList(),
      'siblings': object.siblings
          ?.map((e) => const PassioAlternativeConverter().toJson(e))
          .toList(),
      'children': object.children
          ?.map((e) => const PassioAlternativeConverter().toJson(e))
          .toList(),
      'calories': const UnitEnergyConverter()
          .toJson(actualUnitEnergy(object, object.totalCalories())),
      'vitaminA': const UnitIUConverter()
          .toJson(actualUnitIU(object, object.totalVitaminA())),
      'carbs': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalCarbs())),
      'fat': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalFat())),
      'proteins': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalProteins())),
      'saturatedFat': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalSaturatedFat())),
      'transFat': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalTransFat())),
      'monounsaturatedFat': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalMonounsaturatedFat())),
      'polyunsaturatedFat': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalPolyunsaturatedFat())),
      'cholesterol': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalCholesterol())),
      'sodium': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalSodium())),
      'fibers': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalFibers())),
      'sugars': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalSugars())),
      'sugarsAdded': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalSugarsAdded())),
      'vitaminD': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalVitaminD())),
      'calcium': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalCalcium())),
      'iron': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalIron())),
      'potassium': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalPotassium())),
      'vitaminC': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalVitaminC())),
      'alcohol': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalAlcohol())),
      'sugarAlcohol': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalSugarAlcohol())),
      'vitaminB12Added': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalVitaminB12Added())),
      'vitaminB12': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalVitaminB12())),
      'vitaminB6': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalVitaminB6())),
      'vitaminE': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalVitaminE())),
      'vitaminEAdded': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalVitaminEAdded())),
      'magnesium': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalMagnesium())),
      'phosphorus': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalPhosphorus())),
      'iodine': const UnitMassConverter()
          .toJson(actualUnitMass(object, object.totalIodine())),
    };
  }
}

class UnitEnergyConverter extends JsonConverter<UnitEnergy?, dynamic> {
  const UnitEnergyConverter();

  @override
  UnitEnergy? fromJson(json) {
    /// Parsing the json response.
    final jsonData = Map<String, dynamic>.from(json);

    double value = 0;
    String? symbol;

    if (jsonData.containsKey('value')) {
      value = double.tryParse(jsonData['value'].toString()) ?? 0;
    }
    if (jsonData.containsKey('symbol')) {
      symbol = jsonData['symbol'];
    } else {
      if (jsonData.containsKey('unit')) {
        if (jsonData['unit'] is Map && jsonData.containsKey('symbol')) {
          symbol = jsonData['unit']['symbol'];
        }
      }
    }
    if (symbol != null) {
      return UnitEnergy(
          value,
          UnitEnergyType.values.firstWhere(
              (element) => element.symbol == symbol,
              orElse: () => UnitEnergyType.values.first));
    }
    return null;
  }

  @override
  toJson(UnitEnergy? object) {
    return {
      'value': object?.value.roundNumber(2),
      'converter': object?.converter,
      'symbol': object?.symbol,
      'unit': {
        'index': object?.unit.index,
        'name': object?.unit.name,
        'converter': object?.converter,
        'symbol': object?.symbol,
      }
    };
  }
}

class UnitMassConverter extends JsonConverter<UnitMass?, dynamic> {
  const UnitMassConverter();

  @override
  UnitMass? fromJson(json) {
    /// Parsing the json response.
    final jsonData = Map<String, dynamic>.from(json);

    double value = 0;
    String? symbol;

    if (jsonData.containsKey('value')) {
      value = double.tryParse(jsonData['value'].toString()) ?? 0;
    }
    if (jsonData.containsKey('symbol')) {
      symbol = jsonData['symbol'];
    } else {
      if (jsonData.containsKey('unit')) {
        if (jsonData['unit'] is Map && jsonData['unit'].containsKey('symbol')) {
          symbol = jsonData['unit']['symbol'];
        }
      }
    }
    if (symbol != null) {
      return UnitMass(
          value,
          UnitMassType.values.firstWhere((element) => element.symbol == symbol,
              orElse: () => UnitMassType.values.first));
    }
    return null;
  }

  @override
  toJson(UnitMass? object) {
    return {
      'value': object?.value.roundNumber(2),
      'converter': object?.converter,
      'symbol': object?.symbol,
      'unit': {
        'index': object?.unit.index,
        'name': object?.unit.name,
        'converter': object?.converter,
        'symbol': object?.symbol,
      }
    };
  }
}

class UnitIUConverter extends JsonConverter<UnitIU?, dynamic> {
  const UnitIUConverter();

  @override
  UnitIU? fromJson(json) {
    /// Parsing the json response.
    final jsonData = Map<String, dynamic>.from(json);

    double? value;

    if (jsonData.containsKey('value')) {
      value = double.tryParse(jsonData['value'].toString());
    }
    if (value != null) {
      return UnitIU(value);
    }
    return null;
  }

  @override
  toJson(UnitIU? object) {
    return {
      'value': object?.value.roundNumber(2),
    };
  }
}*/
