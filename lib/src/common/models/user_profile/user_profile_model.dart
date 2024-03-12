import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

import '../../util/double_extensions.dart';

part 'user_profile_model.g.dart';

enum UnitSelection {
  imperial,
  metric,
}

enum WeightUnits {
  lbs,
  kg,
}

enum HeightUnits {
  meter,
  feet,
}

enum GenderSelection {
  female,
  male,
  other,
}

enum Conversion {
  lbsToKg(2.20562),
  inchToMeter(39.3701),
  inchToFeet(12.00);

  final double value;

  const Conversion(this.value);
}

@JsonSerializable(includeIfNull: false)
class UserProfileModel {
  UserProfileModel({
    this.id,
    this.firstName,
    this.lastName,
    this.birthday,
    this.age,
    this.weight,
    this.height,
    this.units = UnitSelection.imperial,
    this.gender,
  });

  String? id;
  String? firstName;
  String? lastName;
  DateTime? birthday;
  int? age;
  double? weight;
  double? height;
  UnitSelection units;
  int caloriesTarget = 2100;
  int carbsPercent = 55;
  int proteinPercent = 20;
  int fatPercent = 25;
  GenderSelection? gender;

  int get carbsGrams => caloriesTarget * carbsPercent / 100 ~/ 4;

  int get proteinGrams => caloriesTarget * proteinPercent / 100 ~/ 4;

  int get fatGrams => caloriesTarget * fatPercent / 100 ~/ 9;

  double? get bmi {
    if (weight != null &&
        height != null &&
        (height ?? 0) > 0 &&
        (weight ?? 0) > 0) {
      return ((weight ?? 0) / pow((height ?? 0), 2)).roundNumber(places: 1) as double;
    }
    return null;
  }

  String? get ageDescription {
    return age?.toString();
  }

  WeightUnits get weightUnits => switch (units) {
        UnitSelection.metric => WeightUnits.kg,
        _ => WeightUnits.lbs,
      };

  String? get weightDescription {
    if (weight != null) {
      return switch (units) {
        UnitSelection.metric => weight.roundNumber(places: 1).toString(),
        _ =>
          ((weight ?? 0) * Conversion.lbsToKg.value).roundNumber(places: 1).toString(),
      };
    }
    return null;
  }

  HeightUnits get heightUnits => switch (units) {
        UnitSelection.metric => HeightUnits.meter,
        _ => HeightUnits.feet,
      };

  String? get heightDescription {
    if (height != null) {
      switch (units) {
        case UnitSelection.metric:
          return height.roundNumber(places: 2).toString();
        default:
          int inches = ((height ?? 0) * Conversion.inchToMeter.value).toInt();
          int inch = (inches % Conversion.inchToFeet.value).toInt();
          int feet = inches ~/ Conversion.inchToFeet.value;
          return '$feet\' $inch"';
      }
    }
    return null;
  }

  String? get bmiDescription {
    if (bmi != null) {
      final cdc = switch (bmi ?? 0) {
        (>= 0 && < 18.5) => "Underweight",
        (>= 18.5 && < 24.9) => "Healthy Weight",
        (>= 24.9 && < 29.9) => "Overweight",
        _ => "Obese",
      };
      return "Body mass index ($bmi)\nCDC ranking:\n($cdc)";
    }
    return null; // We are returning null because need to manage ["BMIPlaceHolder"] text with localization.
  }

  void setWeightInKg(double value) {
    weight = switch (units) {
      UnitSelection.metric => value,
      _ => value / Conversion.lbsToKg.value,
    };
  }

  ({
    List<String>? meter,
    List<String>? centimeter,
    List<String>? feet,
    List<String>? inches
  }) get heightArrayForPicker {
    return switch (units) {
      UnitSelection.metric => (
          meter: List.generate(3, (index) => '$index m'),
          centimeter: List.generate(100, (index) => '$index cm'),
          feet: null,
          inches: null
        ),
      _ => (
          meter: null,
          centimeter: null,
          feet: List.generate(9, (index) => "$index'"),
          inches: List.generate(12, (index) => '$index"')
        ),
    };
  }

  ({int? meter, int? centimeter, int? feet, int? inches})
      get heightInitialValueForPicker {
    return switch (units) {
      UnitSelection.metric => (height != null)
          ? (
              meter: height?.toInt() ?? 0,
              centimeter:
                  (((height ?? 0) - (height?.toInt() ?? 0)) * 100).toInt(),
              feet: null,
              inches: null
            )
          : (meter: 1, centimeter: 65, feet: null, inches: null),
      _ => (height != null)
          ? (
              meter: null,
              centimeter: null,
              feet: ((height ?? 0) * Conversion.inchToMeter.value) ~/
                  Conversion.inchToFeet.value,
              inches: (((height ?? 0) * Conversion.inchToMeter.value) %
                      Conversion.inchToFeet.value)
                  .toInt(),
            )
          : (meter: null, centimeter: null, feet: 5, inches: 6),
    };
  }

  void setHeightInMetersFor(int valueOne, int valueTwo) {
    height = switch (units) {
      UnitSelection.metric => valueOne.toDouble() + valueTwo.toDouble() / 100,
      _ => ((valueOne * Conversion.inchToFeet.value.toInt() + valueTwo) /
              Conversion.inchToMeter.value)
          .toDouble(),
    };
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}
