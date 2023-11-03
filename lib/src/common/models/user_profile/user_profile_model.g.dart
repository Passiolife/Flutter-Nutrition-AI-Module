// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    UserProfileModel(
      id: json['id'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      birthday: json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
      age: json['age'] as int?,
      weight: (json['weight'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      units: $enumDecodeNullable(_$UnitSelectionEnumMap, json['units']) ??
          UnitSelection.imperial,
      gender: $enumDecodeNullable(_$GenderSelectionEnumMap, json['gender']),
    )
      ..caloriesTarget = json['caloriesTarget'] as int
      ..carbsPercent = json['carbsPercent'] as int
      ..proteinPercent = json['proteinPercent'] as int
      ..fatPercent = json['fatPercent'] as int;

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('firstName', instance.firstName);
  writeNotNull('lastName', instance.lastName);
  writeNotNull('birthday', instance.birthday?.toIso8601String());
  writeNotNull('age', instance.age);
  writeNotNull('weight', instance.weight);
  writeNotNull('height', instance.height);
  val['units'] = _$UnitSelectionEnumMap[instance.units]!;
  val['caloriesTarget'] = instance.caloriesTarget;
  val['carbsPercent'] = instance.carbsPercent;
  val['proteinPercent'] = instance.proteinPercent;
  val['fatPercent'] = instance.fatPercent;
  writeNotNull('gender', _$GenderSelectionEnumMap[instance.gender]);
  return val;
}

const _$UnitSelectionEnumMap = {
  UnitSelection.imperial: 'imperial',
  UnitSelection.metric: 'metric',
};

const _$GenderSelectionEnumMap = {
  GenderSelection.female: 'female',
  GenderSelection.male: 'male',
  GenderSelection.other: 'other',
};
