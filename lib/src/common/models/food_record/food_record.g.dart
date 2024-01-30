// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodRecord _$FoodRecordFromJson(Map<String, dynamic> json) => FoodRecord(
      name: json['name'] as String?,
      uuid: json['uuid'] as String?,
      createdAt: (json['createdAt'] as num?)?.toDouble(),
      mealLabel: $enumDecodeNullable(_$MealLabelEnumMap, json['mealLabel']),
      passioID: json['passioID'] as String?,
      visualPassioID: json['visualPassioID'] as String?,
      visualName: json['visualName'] as String?,
      nutritionalPassioID: json['nutritionalPassioID'] as String?,
      servingSizes: (json['servingSizes'] as List<dynamic>?)
          ?.map(const PassioServingSizeConverter().fromJson)
          .toList(),
      servingUnits: (json['servingUnits'] as List<dynamic>?)
          ?.map(const PassioServingUnitConverter().fromJson)
          .toList(),
      scannedUnitName: json['scannedUnitName'] as String? ?? "scanned amount",
      entityType:
          $enumDecodeNullable(_$PassioIDEntityTypeEnumMap, json['entityType']),
      selectedUnit: json['selectedUnit'] as String?,
      selectedQuantity: (json['selectedQuantity'] as num?)?.toDouble() ?? 0,
      ingredients: (json['ingredients'] as List<dynamic>?)
          ?.map(const PassioFoodItemDataConverter().fromJson)
          .toList(),
      condiments: (json['condiments'] as List<dynamic>?)
          ?.map(const PassioFoodItemDataConverter().fromJson)
          .toList(),
      parents: (json['parents'] as List<dynamic>?)
          ?.map(const PassioAlternativeConverter().fromJson)
          .toList(),
      siblings: (json['siblings'] as List<dynamic>?)
          ?.map(const PassioAlternativeConverter().fromJson)
          .toList(),
      children: (json['children'] as List<dynamic>?)
          ?.map(const PassioAlternativeConverter().fromJson)
          .toList(),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$FoodRecordToJson(FoodRecord instance) =>
    <String, dynamic>{
      'name': instance.name,
      'uuid': instance.uuid,
      'createdAt': instance.createdAt,
      'mealLabel': _$MealLabelEnumMap[instance.mealLabel],
      'passioID': instance.passioID,
      'visualPassioID': instance.visualPassioID,
      'visualName': instance.visualName,
      'nutritionalPassioID': instance.nutritionalPassioID,
      'servingSizes': instance.servingSizes
          ?.map(const PassioServingSizeConverter().toJson)
          .toList(),
      'servingUnits': instance.servingUnits
          ?.map(const PassioServingUnitConverter().toJson)
          .toList(),
      'scannedUnitName': instance.scannedUnitName,
      'condiments': instance.condiments
          ?.map(const PassioFoodItemDataConverter().toJson)
          .toList(),
      'entityType': _$PassioIDEntityTypeEnumMap[instance.entityType],
      'selectedUnit': instance.selectedUnit,
      'selectedQuantity': instance.selectedQuantity,
      'ingredients': instance.ingredients
          ?.map(const PassioFoodItemDataConverter().toJson)
          .toList(),
      'parents': instance.parents
          ?.map(const PassioAlternativeConverter().toJson)
          .toList(),
      'siblings': instance.siblings
          ?.map(const PassioAlternativeConverter().toJson)
          .toList(),
      'children': instance.children
          ?.map(const PassioAlternativeConverter().toJson)
          .toList(),
      'tags': instance.tags,
    };

const _$MealLabelEnumMap = {
  MealLabel.breakfast: 'Breakfast',
  MealLabel.lunch: 'Lunch',
  MealLabel.dinner: 'Dinner',
  MealLabel.snack: 'Snack',
};

const _$PassioIDEntityTypeEnumMap = {
  PassioIDEntityType.group: 'group',
  PassioIDEntityType.item: 'item',
  PassioIDEntityType.recipe: 'recipe',
  PassioIDEntityType.barcode: 'barcode',
  PassioIDEntityType.packagedFoodCode: 'packagedFoodCode',
  PassioIDEntityType.nutritionFacts: 'nutritionFacts',
};
