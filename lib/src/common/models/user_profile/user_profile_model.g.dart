// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    UserProfileModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      gender: $enumDecodeNullable(_$GenderSelectionEnumMap, json['gender']) ??
          GenderSelection.male,
      heightUnit:
          $enumDecodeNullable(_$MeasurementSystemEnumMap, json['heightUnit']) ??
              MeasurementSystem.imperial,
      weightUnit:
          $enumDecodeNullable(_$MeasurementSystemEnumMap, json['weightUnit']) ??
              MeasurementSystem.imperial,
    )
      .._age = json['_age'] as int?
      .._weight = (json['_weight'] as num?)?.toDouble()
      .._targetWeight = (json['_targetWeight'] as num).toDouble()
      .._targetWater = (json['_targetWater'] as num).toDouble()
      .._activityLevel =
          $enumDecodeNullable(_$ActivityLevelEnumMap, json['_activityLevel'])
      .._height = (json['_height'] as num?)?.toDouble()
      .._calorieDeficit =
          $enumDecode(_$CalorieDeficitEnumMap, json['_calorieDeficit'])
      .._mealPlan = json['_mealPlan'] == null
          ? null
          : PassioMealPlan.fromJson(json['_mealPlan'] as Map<String, dynamic>)
      ..caloriesTarget = json['caloriesTarget'] as int
      ..carbsPercentage = json['carbsPercentage'] as int
      ..proteinPercentage = json['proteinPercentage'] as int
      ..fatPercentage = json['fatPercentage'] as int;

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      '_age': instance._age,
      '_weight': instance._weight,
      '_targetWeight': instance._targetWeight,
      'gender': _$GenderSelectionEnumMap[instance.gender]!,
      'heightUnit': _$MeasurementSystemEnumMap[instance.heightUnit]!,
      'weightUnit': _$MeasurementSystemEnumMap[instance.weightUnit]!,
      '_targetWater': instance._targetWater,
      '_activityLevel': _$ActivityLevelEnumMap[instance._activityLevel],
      '_height': instance._height,
      '_calorieDeficit': _$CalorieDeficitEnumMap[instance._calorieDeficit]!,
      '_mealPlan': instance._mealPlan?.toJson(),
      'caloriesTarget': instance.caloriesTarget,
      'carbsPercentage': instance.carbsPercentage,
      'proteinPercentage': instance.proteinPercentage,
      'fatPercentage': instance.fatPercentage,
    };

const _$GenderSelectionEnumMap = {
  GenderSelection.male: 'male',
  GenderSelection.female: 'female',
};

const _$MeasurementSystemEnumMap = {
  MeasurementSystem.metric: 'metric',
  MeasurementSystem.imperial: 'imperial',
};

const _$ActivityLevelEnumMap = {
  ActivityLevel.notActive: 'notActive',
  ActivityLevel.lightlyActive: 'lightlyActive',
  ActivityLevel.moderatelyActive: 'moderatelyActive',
  ActivityLevel.active: 'active',
};

const _$CalorieDeficitEnumMap = {
  CalorieDeficit.lose0_5: 'lose0_5',
  CalorieDeficit.lose1_0: 'lose1_0',
  CalorieDeficit.lose1_5: 'lose1_5',
  CalorieDeficit.lose2_0: 'lose2_0',
  CalorieDeficit.gain0_5: 'gain0_5',
  CalorieDeficit.gain1_0: 'gain1_0',
  CalorieDeficit.gain1_5: 'gain1_5',
  CalorieDeficit.gain2_0: 'gain2_0',
  CalorieDeficit.maintainWeight: 'maintainWeight',
};
