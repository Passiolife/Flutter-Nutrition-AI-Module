import 'package:flutter/foundation.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../extension/map_extension.dart';
import 'food_record.dart';

/// Represents an ingredient of a food record.
class FoodRecordIngredient {
  /// Unique identifier for the ingredient.
  String id = '';

  /// Passio identifier for the food record.
  String passioID;

  /// A reference code serving as a unique identifier for the food item.
  String refCode;

  /// The reference ID of the place from which this entry is logged.
  String? sourceId;

  /// Name of the ingredient.
  String name = '';

  /// Additional data for the food item.
  String additionalData = '';

  /// Identifier for the icon of the ingredient.
  String iconId = '';

  /// Currently selected unit for measurement.
  String selectedUnit = '';

  /// Quantity of the ingredient.
  double selectedQuantity = 0;

  /// Available serving sizes for the ingredient.
  List<PassioServingSize> servingSizes;

  /// Available serving units for the ingredient.
  List<PassioServingUnit> servingUnits;

  /// Nutritional information of the ingredient.
  PassioNutrients referenceNutrients;

  /// License information for open food data.
  String? openFoodLicense;

  /// Type of Passio ID entity.
  PassioIDEntityType entityType;

  String? barcode;

  /// Private constructor for creating a FoodRecordIngredient instance with specified properties.
  FoodRecordIngredient._({
    required this.id,
    required this.passioID,
    required this.refCode,
    required this.name,
    required this.additionalData,
    required this.iconId,
    required this.servingSizes,
    required this.servingUnits,
    required this.selectedQuantity,
    required this.selectedUnit,
    required this.entityType,
    required this.referenceNutrients,
    this.sourceId,
    this.openFoodLicense,
    this.barcode,
  });

  /// Factory constructor to create a FoodRecordIngredient from a FoodRecord instance.
  factory FoodRecordIngredient.fromFoodRecord(FoodRecord foodRecord,
      {PassioIDEntityType entityType = PassioIDEntityType.item}) {
    return FoodRecordIngredient._(
      id: foodRecord.id,
      passioID: foodRecord.passioID,
      refCode: foodRecord.refCode,
      name: foodRecord.name,
      additionalData: foodRecord.additionalData,
      iconId: foodRecord.iconId,
      servingSizes: foodRecord.servingSizes,
      servingUnits: foodRecord.servingUnits,
      selectedQuantity: foodRecord.getSelectedQuantity(),
      selectedUnit: foodRecord.getSelectedUnit(),
      entityType: entityType,
      referenceNutrients: foodRecord.nutrients(),
      openFoodLicense: foodRecord.openFoodLicense,
      barcode: foodRecord.barcode,
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
      additionalData: '',
      iconId: ingredient.iconId,
      servingSizes: ingredient.amount.servingSizes,
      servingUnits: ingredient.amount.servingUnits,
      selectedQuantity: ingredient.amount.selectedQuantity,
      selectedUnit: ingredient.amount.selectedUnit,
      entityType: entityType,
      referenceNutrients: ingredient.referenceNutrients,
      openFoodLicense: ingredient.metadata.openFoodLicense(),
      barcode: ingredient.metadata.barcode,
    );
  }

  /// Creates a [FoodRecordIngredient] instance from a JSON object.
  factory FoodRecordIngredient.fromJson(Map<String, dynamic> json) =>
      FoodRecordIngredient._(
        id: json['id'] as String,
        passioID: json['passioID'] as String,
        refCode: json['refCode'] as String,
        sourceId: json.ifValueNotNull<String>('sourceId'),
        name: json['name'] as String,
        additionalData: json['additionalData'] as String,
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
        barcode: json['barcode'] as String?,
      );

  /// Converts the [FoodRecordIngredient] instance to a JSON object.
  Map<String, dynamic> toJson() => {
        'id': id,
        'passioID': passioID,
        'refCode': refCode,
        'sourceId': sourceId,
        'name': name,
        'additionalData': additionalData,
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
        'barcode': barcode,
      };

  /// Overrides the equality operator.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FoodRecordIngredient &&
        id == other.id &&
        passioID == other.passioID &&
        refCode == other.refCode &&
        sourceId == other.sourceId &&
        name == other.name &&
        additionalData == other.additionalData &&
        iconId == other.iconId &&
        selectedUnit == other.selectedUnit &&
        selectedQuantity == other.selectedQuantity &&
        listEquals(servingSizes, other.servingSizes) &&
        listEquals(servingUnits, other.servingUnits) &&
        entityType == other.entityType &&
        referenceNutrients == other.referenceNutrients &&
        openFoodLicense == other.openFoodLicense &&
        barcode == other.barcode;
  }

  /// Overrides the hashCode method.
  @override
  int get hashCode {
    return Object.hash(
      id,
      passioID,
      refCode,
      sourceId,
      name,
      additionalData,
      iconId,
      selectedUnit,
      selectedQuantity,
      servingSizes,
      servingUnits,
      entityType,
      referenceNutrients,
      openFoodLicense,
      barcode,
    );
  }

  FoodRecordIngredient clone() {
    final json = toJson();
    return FoodRecordIngredient.fromJson(json);
  }

  /// Calculates the serving weight of the ingredient based on the selected unit and quantity.
  UnitMass servingWeight() => ((servingUnits
          .firstWhere((element) => element.unitName == selectedUnit)
          .weight) *
      selectedQuantity as UnitMass);

  /// Calculates the nutritional information for the selected serving size based on the reference nutrients.
  ///
  /// Returns a [PassioNutrients] object representing the calculated nutritional information.
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
