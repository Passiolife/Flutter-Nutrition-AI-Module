import 'package:flutter/foundation.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import 'food_record.dart';

/// Represents an ingredient of a food record.
class FoodRecordIngredient {
  /// Unique identifier for the ingredient.
  String id = '';

  String passioID;

  String refCode;

  /// Name of the ingredient.
  String name = '';

  /// Identifier for the icon of the ingredient.
  String iconId = '';

  /// Currently selected unit for measurement.
  String selectedUnit = '';

  /// Quantity of the ingredient.
  double selectedQuantity = 0;

  /// Available serving sizes for the ingredient.
  late List<PassioServingSize> servingSizes;

  /// Available serving units for the ingredient.
  late List<PassioServingUnit> servingUnits;

  /// Nutritional information of the ingredient.
  PassioNutrients referenceNutrients;

  /// License information for open food data.
  String? openFoodLicense;

  PassioIDEntityType entityType;

  /// Private constructor for creating a FoodRecordIngredient instance with specified properties.
  FoodRecordIngredient._({
    required this.id,
    required this.passioID,
    required this.refCode,
    required this.name,
    required this.iconId,
    required this.servingSizes,
    required this.servingUnits,
    required this.selectedQuantity,
    required this.selectedUnit,
    required this.entityType,
    required this.referenceNutrients,
    this.openFoodLicense,
  });

  /// Factory constructor to create a FoodRecordIngredient from a FoodRecord instance.
  factory FoodRecordIngredient.fromFoodRecord(FoodRecord foodRecord,
      {PassioIDEntityType entityType = PassioIDEntityType.item}) {
    return FoodRecordIngredient._(
      id: foodRecord.id,
      passioID: foodRecord.passioID,
      refCode: foodRecord.refCode,
      name: foodRecord.name,
      iconId: foodRecord.iconId,
      servingSizes: foodRecord.servingSizes,
      servingUnits: foodRecord.servingUnits,
      selectedQuantity: foodRecord.getSelectedQuantity(),
      selectedUnit: foodRecord.getSelectedUnit(),
      entityType: entityType,
      referenceNutrients: foodRecord.nutrients(),
      openFoodLicense: foodRecord.openFoodLicense,
    );
  }

  /// Factory constructor to create a FoodRecordIngredient from a PassioIngredient instance.
  factory FoodRecordIngredient.fromPassioIngredient(PassioIngredient ingredient,
      {PassioIDEntityType entityType = PassioIDEntityType.item}) {
    return FoodRecordIngredient._(
      id: '',
      passioID: ingredient.id,
      refCode: ingredient.refCode,
      name: ingredient.name,
      iconId: ingredient.iconId,
      servingSizes: ingredient.amount.servingSizes,
      servingUnits: ingredient.amount.servingUnits,
      selectedQuantity: ingredient.amount.selectedQuantity,
      selectedUnit: ingredient.amount.selectedUnit,
      entityType: entityType,
      referenceNutrients: ingredient.referenceNutrients,
      openFoodLicense: ingredient.metadata.openFoodLicense(),
    );
  }

  factory FoodRecordIngredient.fromJson(Map<String, dynamic> json) =>
      FoodRecordIngredient._(
        id: json['id'] as String,
        passioID: json['passioID'] as String,
        refCode: json['refCode'] as String,
        name: json['name'] as String,
        iconId: json['iconId'] as String,
        selectedUnit: json['selectedUnit'] as String,
        selectedQuantity: (json['selectedQuantity'] as num).toDouble(),
        servingSizes: List<PassioServingSize>.from(
          json['servingSizes']
                  ?.map((dynamic s) => PassioServingSize.fromJson(s)) ??
              [],
        ),
        servingUnits: List<PassioServingUnit>.from(
          json['servingUnits']
                  ?.map((dynamic s) => PassioServingUnit.fromJson(s)) ??
              [],
        ),
        entityType: PassioIDEntityType.values.firstWhere(
            (element) => element.name == json['entityType'],
            orElse: () => PassioIDEntityType.item),
        referenceNutrients: PassioNutrients.fromJson(
            json['referenceNutrients'] as Map<String, dynamic>),
        openFoodLicense: json['openFoodLicense'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'passioID': passioID,
        'refCode': refCode,
        'name': name,
        'iconId': iconId,
        'selectedUnit': selectedUnit,
        'selectedQuantity': selectedQuantity,
        'servingSizes':
            servingSizes.map((PassioServingSize s) => s.toJson()).toList(),
        'servingUnits':
            servingUnits.map((PassioServingUnit s) => s.toJson()).toList(),
        'entityType': entityType.name,
        'referenceNutrients': referenceNutrients.toJson(),
        'openFoodLicense': openFoodLicense,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FoodRecordIngredient &&
        id == other.id &&
        passioID == other.passioID &&
        refCode == other.refCode &&
        name == other.name &&
        iconId == other.iconId &&
        selectedUnit == other.selectedUnit &&
        selectedQuantity == other.selectedQuantity &&
        listEquals(servingSizes, other.servingSizes) &&
        listEquals(servingUnits, other.servingUnits) &&
        entityType == other.entityType &&
        referenceNutrients == other.referenceNutrients &&
        openFoodLicense == other.openFoodLicense;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      passioID,
      refCode,
      name,
      iconId,
      selectedUnit,
      selectedQuantity,
      servingSizes,
      servingUnits,
      entityType,
      referenceNutrients,
      openFoodLicense,
    );
  }

  /// Calculates the serving weight of the ingredient based on the selected unit and quantity.
  UnitMass servingWeight() => ((servingUnits
          .firstWhere((element) => element.unitName == selectedUnit)
          .weight) *
      selectedQuantity as UnitMass);

  PassioNutrients nutrientsSelectedSize() =>
      PassioNutrients.fromReferenceNutrients(referenceNutrients,
          weight: servingWeight());

  /// Retrieves the reference nutrients of the ingredient.
  PassioNutrients nutrientsReference() => referenceNutrients;

  /// [computedWeight] is [UnitMass] class and contains weight.
  UnitMass get computedWeight {
    final weight2UnitRatio = servingUnits
        .cast<PassioServingUnit?>()
        .firstWhere((element) => element?.unitName == selectedUnit,
            orElse: () => null)
        ?.weight
        .value;
    if (weight2UnitRatio != null) {
      return UnitMass(weight2UnitRatio * selectedQuantity, UnitMassType.grams);
    }
    return UnitMass(0, UnitMassType.grams);
  }
}
