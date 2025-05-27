import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../../common/extension/core_extension.dart';
import '../../../common/models/food_record/food_record.dart';
import '../../../common/models/food_record/food_record_ingredient.dart';
import '../../../common/models/key_value_model.dart';

class FoodCreatorModel {
  FoodCreatorModel() {
    _unit = units.first;

    if (kDebugMode) {
      _name = 'Apple';
      _brand = 'Kashmiri';
      _barcode = 'AAA';
      _servingSize = 1;
      _weight = 150;
      _calories = 52;
      _fat = 0.2;
      _carbs = 14;
      _protein = 0.3;
      for (var element in _allOtherNutritionFacts) {
        selectOtherNutritionFact(KeyValueModel(
            text: element.text,
            value: UnitMass(Random().nextDouble(), element.value.unit)));
      }
    }
  }

  FoodCreatorModel.fromFoodRecord(FoodRecord foodRecord, {Uint8List? image}) {
    _id = foodRecord.id;

    _iconId = foodRecord.iconId;
    _image = image;
    _name = foodRecord.name;
    _brand = foodRecord.additionalData;
    _barcode = foodRecord.barcode;

    // Required Nutrition Facts
    setServingSize(foodRecord.getSelectedQuantity());
    final KeyValueModel<String> selectedUnit = units
        .firstWhere((element) => element.value == foodRecord.getSelectedUnit());
    setUnit(selectedUnit);
    setWeight(foodRecord.computedWeight.value);
    final KeyValueModel<String> selectedWeightSymbol = weightSymbols.firstWhere(
        (element) => element.value == foodRecord.computedWeight.symbol);
    setWeightSymbol(selectedWeightSymbol);

    foodRecord.nutrientsSelectedSize().calories?.let((value) {
      setCalories(value.value);
    });
    foodRecord.nutrientsSelectedSize().fat?.let((value) {
      setFat(value.value);
    });
    foodRecord.nutrientsSelectedSize().carbs?.let((value) {
      setCarbs(value.value);
    });
    foodRecord.nutrientsSelectedSize().proteins?.let((value) {
      setProtein(value.value);
    });

    // Other Nutrition Facts
    foodRecord.nutrientsSelectedSize().satFat.let((value) {
      final KeyValueModel<UnitMass> selectedNutrient = _allOtherNutritionFacts
          .firstWhere((element) => element.text == 'Saturated Fat');
      final KeyValueModel<UnitMass> updatedNutrient =
          selectedNutrient.copyWith(value: value);
      selectOtherNutritionFact(updatedNutrient);
    });

    foodRecord.nutrientsSelectedSize().transFat.let((value) {
      final KeyValueModel<UnitMass> selectedNutrient = _allOtherNutritionFacts
          .firstWhere((element) => element.text == 'Trans Fat');
      final KeyValueModel<UnitMass> updatedNutrient =
          selectedNutrient.copyWith(value: value);
      selectOtherNutritionFact(updatedNutrient);
    });

    foodRecord.nutrientsSelectedSize().cholesterol.let((value) {
      final KeyValueModel<UnitMass> selectedNutrient = _allOtherNutritionFacts
          .firstWhere((element) => element.text == 'Cholesterol');
      final KeyValueModel<UnitMass> updatedNutrient =
          selectedNutrient.copyWith(value: value);
      selectOtherNutritionFact(updatedNutrient);
    });

    foodRecord.nutrientsSelectedSize().sodium.let((value) {
      final KeyValueModel<UnitMass> selectedNutrient = _allOtherNutritionFacts
          .firstWhere((element) => element.text == 'Sodium');
      final KeyValueModel<UnitMass> updatedNutrient =
          selectedNutrient.copyWith(value: value);
      selectOtherNutritionFact(updatedNutrient);
    });

    foodRecord.nutrientsSelectedSize().fibers.let((value) {
      final KeyValueModel<UnitMass> selectedNutrient = _allOtherNutritionFacts
          .firstWhere((element) => element.text == 'Dietary Fiber');
      final KeyValueModel<UnitMass> updatedNutrient =
          selectedNutrient.copyWith(value: value);
      selectOtherNutritionFact(updatedNutrient);
    });

    foodRecord.nutrientsSelectedSize().sugars.let((value) {
      final KeyValueModel<UnitMass> selectedNutrient = _allOtherNutritionFacts
          .firstWhere((element) => element.text == 'Total Sugars');
      final KeyValueModel<UnitMass> updatedNutrient =
          selectedNutrient.copyWith(value: value);
      selectOtherNutritionFact(updatedNutrient);
    });

    foodRecord.nutrientsSelectedSize().sugarsAdded.let((value) {
      final KeyValueModel<UnitMass> selectedNutrient = _allOtherNutritionFacts
          .firstWhere((element) => element.text == 'Added Sugar');
      final KeyValueModel<UnitMass> updatedNutrient =
          selectedNutrient.copyWith(value: value);
      selectOtherNutritionFact(updatedNutrient);
    });

    foodRecord.nutrientsSelectedSize().vitaminD.let((value) {
      final KeyValueModel<UnitMass> selectedNutrient = _allOtherNutritionFacts
          .firstWhere((element) => element.text == 'Vitamin D');
      final KeyValueModel<UnitMass> updatedNutrient =
          selectedNutrient.copyWith(value: value);
      selectOtherNutritionFact(updatedNutrient);
    });

    foodRecord.nutrientsSelectedSize().calcium.let((value) {
      final KeyValueModel<UnitMass> selectedNutrient = _allOtherNutritionFacts
          .firstWhere((element) => element.text == 'Calcium');
      final KeyValueModel<UnitMass> updatedNutrient =
          selectedNutrient.copyWith(value: value);
      selectOtherNutritionFact(updatedNutrient);
    });

    foodRecord.nutrientsSelectedSize().potassium.let((value) {
      final KeyValueModel<UnitMass> selectedNutrient = _allOtherNutritionFacts
          .firstWhere((element) => element.text == 'Potassium');
      final KeyValueModel<UnitMass> updatedNutrient =
          selectedNutrient.copyWith(value: value);
      selectOtherNutritionFact(updatedNutrient);
    });
  }

  // General
  String _id = '';

  // Food Details
  String? _iconId;
  Uint8List? _image;
  bool _isImageUpdate = false;
  String? _name;
  String _brand = '';
  String? _barcode;

  // Required Nutrition Facts
  double? _servingSize;
  double? _weight;
  double? _calories;
  double? _fat;
  double? _carbs;
  double? _protein;

  // Units
  static const List<String> _units = [
    'serving',
    'piece',
    'small',
    'medium',
    'large',
    'cup',
    'oz',
    'g',
    'ml',
    'handful',
    'scoop',
    'tbsp',
    'tsp',
    'slice',
    'can',
    'bottle',
    'bar',
    'packet',
  ];

  static const List<KeyValueModel<String>> _weightSymbols = [
    KeyValueModel(text: 'g', value: 'g'),
    KeyValueModel(text: 'ml', value: 'ml')
  ];

  List<KeyValueModel<String>> get weightSymbols => _weightSymbols;
  KeyValueModel<String> _selectedWeightSymbol = _weightSymbols.first;

  bool get isWeightUnit => weightSymbols.contains(unit);

  List<KeyValueModel<String>> get units =>
      _units.map((e) => KeyValueModel(text: e, value: e)).toList();
  KeyValueModel<String>? _unit;

  KeyValueModel<String>? get unit => _unit;

  // Other Nutrition Facts
  // TODO: Iron is missing need to add
  static const Map<String, UnitMassType> _nutrientTypes = {
    'Saturated Fat': UnitMassType.grams,
    'Trans Fat': UnitMassType.grams,
    'Cholesterol': UnitMassType.milligrams,
    'Sodium': UnitMassType.milligrams,
    'Dietary Fiber': UnitMassType.grams,
    'Total Sugars': UnitMassType.grams,
    'Added Sugar': UnitMassType.grams,
    'Vitamin D': UnitMassType.micrograms,
    'Calcium': UnitMassType.milligrams,
    'Potassium': UnitMassType.milligrams,
  };

  final List<KeyValueModel<UnitMass>> _allOtherNutritionFacts =
      _nutrientTypes.entries
          .map((entry) => KeyValueModel(
                text: entry.key,
                value: UnitMass(-1, entry.value),
              ))
          .toList();

  final List<KeyValueModel<UnitMass>> _selectedOtherNutritionFacts = [];

  List<KeyValueModel<UnitMass>> get selectedOtherNutritionFacts =>
      _selectedOtherNutritionFacts;

  UnitMass? getSelectedOtherNutritionFactValue(String text) {
    return _selectedOtherNutritionFacts
        .cast<KeyValueModel<UnitMass>?>()
        .firstWhere(
          (element) => element?.text == text,
          orElse: () => null,
        )
        ?.value;
  }

  // List<KeyValueModel<UnitMass>> get remainingOtherNutritionFacts => _allOtherNutritionFacts..removeWhere((element) => _selectedOtherNutritionFacts.any((e) => e.text == element.text));
  List<KeyValueModel<UnitMass>> get remainingOtherNutritionFacts {
    final Set<String> selectedTexts =
        _selectedOtherNutritionFacts.map((e) => e.text).toSet();
    return _allOtherNutritionFacts
        .where((e) => !selectedTexts.contains(e.text))
        .toList();
  }

  void setImage(Uint8List image) {
    _isImageUpdate = true;
    _image = image;
  }

  Uint8List? getImage() {
    return _image;
  }

  void setIconId(String iconId) {
    _iconId = iconId;
  }

  String? getIconId() {
    return _iconId;
  }

  void setName(String name) {
    _name = name;
  }

  String getId() {
    return _id;
  }

  String? getName() {
    return _name;
  }

  void setBrand(String brand) {
    _brand = brand;
  }

  String getBrand() {
    return _brand;
  }

  void setBarcode(String barcode) {
    _barcode = barcode;
  }

  String? getBarcode() {
    return _barcode;
  }

  void setServingSize(double servingSize) {
    _servingSize = servingSize;
  }

  double? getServingSize() {
    return _servingSize;
  }

  void setUnit(KeyValueModel<String> selectedUnit) {
    _unit = selectedUnit;
    if (isWeightUnit) {
      _weight = null;
      _selectedWeightSymbol = _weightSymbols.first;
    }
  }

  KeyValueModel<String>? getUnit() {
    return _unit;
  }

  void setWeight(double weight) {
    _weight = weight;
  }

  double? getWeight() {
    return _weight;
  }

  void setWeightSymbol(KeyValueModel<String> selectedWeightSymbol) {
    _selectedWeightSymbol = selectedWeightSymbol;
  }

  KeyValueModel<String> getSelectedWeightSymbol() {
    return _selectedWeightSymbol;
  }

  void setCalories(double calories) {
    _calories = calories;
  }

  double? getCalories() {
    return _calories;
  }

  void setFat(double fat) {
    _fat = fat;
  }

  double? getFat() {
    return _fat;
  }

  void setCarbs(double carbs) {
    _carbs = carbs;
  }

  double? getCarbs() {
    return _carbs;
  }

  void setProtein(double protein) {
    _protein = protein;
  }

  double? getProtein() {
    return _protein;
  }

  void selectOtherNutritionFact(KeyValueModel<UnitMass> selectedNutrient) {
    _selectedOtherNutritionFacts.add(selectedNutrient);
  }

  void removeOtherNutritionFact(KeyValueModel<UnitMass> selectedNutrient) {
    _selectedOtherNutritionFacts
        .removeWhere((element) => element.text == selectedNutrient.text);
  }

  void updateOtherNutritionFact(KeyValueModel<UnitMass> selectedNutrient) {
    final index = _selectedOtherNutritionFacts
        .indexWhere((element) => element.text == selectedNutrient.text);
    if (index != -1) {
      _selectedOtherNutritionFacts[index] = selectedNutrient;
    }
  }

  bool isImageUpdate() {
    return _isImageUpdate;
  }

  FoodRecord? toFoodRecord() {
    String id = getId();
    String? name = getName();
    double? servingSize = getServingSize();
    String? unitName = getUnit()?.value;
    double? weight = getWeight();
    double? calories = getCalories();
    double? fat = getFat();
    double? carbs = getCarbs();
    double? protein = getProtein();
    String? barcode = getBarcode();

    String weightSymbol = getSelectedWeightSymbol().value;

    if (name == null ||
        servingSize == null ||
        unitName == null ||
        weight == null ||
        calories == null ||
        fat == null ||
        carbs == null ||
        protein == null) {
      return null;
    }
    final servingSizes = [PassioServingSize(servingSize, unitName)];

    double servingWeightValue = isWeightUnit ? 1 : weight / servingSize;

    final UnitMassType weightUnitType =
        weightSymbol == 'ml' ? UnitMassType.milliliter : UnitMassType.grams;

    UnitMass servingWeight = UnitMass(
      servingWeightValue,
      weightUnitType,
    );

    final List<PassioServingUnit> servingUnits = [
      PassioServingUnit(unitName, servingWeight),
      PassioServingUnit('gram', UnitMass(1, UnitMassType.grams)),
    ];

    final PassioFoodAmount amount = PassioFoodAmount(
      selectedQuantity: servingSize,
      selectedUnit: unitName,
      servingSizes: servingSizes,
      servingUnits: servingUnits,
    );

    final metadata = PassioFoodMetadata(barcode: barcode);
    final String brand = getBrand();
    final selectedWeight = UnitMass(weight, weightUnitType);

    // Required Nutrition Facts
    final UnitEnergy caloriesUnit =
        UnitEnergy(calories, UnitEnergyType.kilocalories);
    final UnitMass fatUnit = UnitMass(fat, UnitMassType.grams);
    final UnitMass carbsUnit = UnitMass(carbs, UnitMassType.grams);
    final UnitMass proteinsUnit = UnitMass(protein, UnitMassType.grams);

    // Other Nutrition Facts
    final UnitMass? satFat =
        getSelectedOtherNutritionFactValue('Saturated Fat');
    final UnitMass? transFat = getSelectedOtherNutritionFactValue('Trans Fat');
    final UnitMass? cholesterol =
        getSelectedOtherNutritionFactValue('Cholesterol');
    final UnitMass? sodium = getSelectedOtherNutritionFactValue('Sodium');
    final UnitMass? dietaryFiber =
        getSelectedOtherNutritionFactValue('Dietary Fiber');
    final UnitMass? totalSugars =
        getSelectedOtherNutritionFactValue('Total Sugars');
    final UnitMass? addedSugars =
        getSelectedOtherNutritionFactValue('Added Sugar');
    final UnitMass? vitaminD = getSelectedOtherNutritionFactValue('Vitamin D');
    final UnitMass? calcium = getSelectedOtherNutritionFactValue('Calcium');
    final UnitMass? potassium = getSelectedOtherNutritionFactValue('Potassium');

    final referenceNutrients = PassioNutrients.fromNutrients(
      weight: selectedWeight,
      calories: caloriesUnit,
      fat: fatUnit,
      carbs: carbsUnit,
      proteins: proteinsUnit,
      satFat: satFat,
      transFat: transFat,
      cholesterol: cholesterol,
      sodium: sodium,
      fibers: dietaryFiber,
      sugars: totalSugars,
      sugarsAdded: addedSugars,
      vitaminD: vitaminD,
      calcium: calcium,
      potassium: potassium,
    );

    String iconId = isImageUpdate()
        ? '${FoodRecord.userFoodPrefix}_${DateTime.now().millisecondsSinceEpoch}'
        : _iconId != null ? _iconId! : FoodRecord.userFoodPrefix;

    final ingredient = PassioIngredient(
      amount: amount,
      iconId: iconId,
      id: '',
      metadata: metadata,
      name: name,
      refCode: '',
      referenceNutrients: referenceNutrients,
    );

    final foodRecordIngredient =
        FoodRecordIngredient.fromPassioIngredient(ingredient);
    foodRecordIngredient.id = id;
    foodRecordIngredient.additionalData = brand;

    final foodRecord =
        FoodRecord.fromFoodRecordIngredient(foodRecordIngredient);

    return foodRecord;
  }
}
