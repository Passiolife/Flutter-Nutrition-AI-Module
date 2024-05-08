import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import '../../util/double_extensions.dart';

part 'user_profile_model.g.dart';

/// Represents different measurement systems for units.
enum MeasurementSystem {
  // The metric measurement system.
  ///
  /// For weight, it uses kilograms (kg).
  /// For height, it primarily uses meters (m) and centimeters (cm).
  /// For water, it uses liters (L) or milliliters (mL).
  metric,

  /// The imperial measurement system.
  ///
  /// For weight, it uses pounds (lbs).
  /// For height, it primarily uses feet (ft) and inches (in).
  /// For water, it uses ounces (oz).
  imperial,
}

enum WeightUnits {
  lbs,
  kg,
}

enum WaterUnits {
  oz,
  ml,
}

enum HeightUnit {
  meter,
  centimeter,
  feet,
  inches,
}

enum GenderSelection {
  male,
  female,
}

// Define an enum to represent different conversion factors
enum Conversion {
  centiMeterToMeter(100),
  meterToInch(39.3701),
  feetToInch(12),
  kgToLbs(2.2046),
  mlToOz(0.0338);

  final double value;

  // Constructor to initialize the value of each conversion factor
  const Conversion(this.value);
}

enum ActivityLevel {
  notActive,
  lightlyActive,
  moderatelyActive,
  active;
}

enum CalorieDeficit {
  lose0_5(0.5),
  lose1_0(1.0),
  lose1_5(1.5),
  lose2_0(2.0),
  gain0_5(0.5),
  gain1_0(1.0),
  gain1_5(1.5),
  gain2_0(2.0),
  maintainWeight(0);

  final double value;

  const CalorieDeficit(this.value);

  double getValue(MeasurementSystem unit) {
    return (unit == MeasurementSystem.imperial)
        ? value
        : value / Conversion.kgToLbs.value;
  }
}

@JsonSerializable(explicitToJson: true)
class UserProfileModel {
  UserProfileModel({
    this.id,
    this.name,
    int? age,
    this.gender = GenderSelection.male,
    double? weight,
    double? height,
    this.heightUnit = MeasurementSystem.imperial,
    this.weightUnit = MeasurementSystem.imperial,
    double targetWeight = 58.967,
    double targetWater = 591.471,
    ActivityLevel? activityLevel,
    CalorieDeficit calorieDeficit = CalorieDeficit.maintainWeight,
  })  : _age = age,
        _activityLevel = activityLevel,
        _weight = weight,
        _height = height,
        _targetWeight = targetWeight,
        _targetWater = targetWater,
        _calorieDeficit = calorieDeficit;

  String? id;
  String? name;

  // Age
  @JsonKey(includeFromJson: true, includeToJson: true)
  int? _age;

  void setAge(int? age) {
    if (_age == age) return;
    _age = age;
    int calories = _calculateRecommendedCalorie();
    if (calories > 0) {
      caloriesTarget = calories;
    }
  }

  int? getAge() => _age;

  // Weight
  @JsonKey(includeFromJson: true, includeToJson: true)
  double? _weight;

  void setWeight(double? weight) {
    if (_weight == weight) return;
    _weight = switch (weightUnit) {
      MeasurementSystem.imperial => (weight ?? 0) / Conversion.kgToLbs.value,
      _ => weight,
    };
    int calories = _calculateRecommendedCalorie();
    if (calories > 0) {
      caloriesTarget = calories;
    }
  }

  double? getWeight() {
    if (_weight != null) {
      return switch (weightUnit) {
        MeasurementSystem.imperial => (_weight ?? 0) * Conversion.kgToLbs.value,
        _ => _weight,
      };
    }
    return null;
  }

  @JsonKey(includeFromJson: true, includeToJson: true)
  double _targetWeight;

  void setTargetWeight(double weight) {
    _targetWeight = switch (weightUnit) {
      MeasurementSystem.imperial => weight / Conversion.kgToLbs.value,
      _ => weight,
    };
  }

  double? getTargetWeight() {
    return switch (weightUnit) {
      MeasurementSystem.imperial => _targetWeight * Conversion.kgToLbs.value,
      _ => _targetWeight,
    };
  }

  GenderSelection gender;
  MeasurementSystem heightUnit;
  MeasurementSystem weightUnit;

  @JsonKey(includeFromJson: true, includeToJson: true)
  double _targetWater;

  void setTargetWater(double water) {
    _targetWater = switch (weightUnit) {
      MeasurementSystem.imperial => water / Conversion.mlToOz.value,
      _ => water,
    };
  }

  double? getTargetWater() {
    return switch (weightUnit) {
      MeasurementSystem.imperial =>
        (_targetWater * Conversion.mlToOz.value).parseFormatted(),
      _ => _targetWater.parseFormatted(),
    };
  }

  // ActivityLevel
  @JsonKey(includeFromJson: true, includeToJson: true)
  ActivityLevel? _activityLevel;

  void setActivityLevel(ActivityLevel? activityLevel) {
    if (_activityLevel == activityLevel) return;
    _activityLevel = activityLevel;
    int calories = _calculateRecommendedCalorie();
    if (calories > 0) {
      caloriesTarget = calories;
    }
  }

  ActivityLevel? getActivityLevel() => _activityLevel;

  // Height
  @JsonKey(includeFromJson: true, includeToJson: true)
  double? _height;

  // Method to set the height based on the provided values and the current measurement system
  void setHeight(int value1, int value2) {
    // Switch based on the measurement system
    switch (heightUnit) {
      case MeasurementSystem.metric:
        // If the measurement system is metric, calculate height in meters
        _height = value1 + (value2 / Conversion.centiMeterToMeter.value);
        break;
      default:
        // If the measurement system is imperial, convert height to meters
        _height = ((value1 * Conversion.feetToInch.value) + value2) /
            Conversion.meterToInch.value;
    }
  }

  double? getHeight() => _height;

  // Method to get the height in the specified measurement system
  ({int unit, int subunit}) get heightInMeasurementSystem {
    switch (heightUnit) {
      case MeasurementSystem.metric:
        // If the measurement system is metric, calculate height in meters and centimeters
        int meters = _height?.toInt() ?? 0;
        int centimeter = (((_height ?? 0) - (_height?.toInt() ?? 0)).round() *
                Conversion.centiMeterToMeter.value)
            .toInt();
        return _height != null
            ? (unit: meters, subunit: centimeter)
            : (unit: 1, subunit: 6);
      default:
        // If the measurement system is imperial, calculate height in feet and inches
        int feet = ((_height ?? 0) * Conversion.meterToInch.value) ~/
            Conversion.feetToInch.value;
        int inches = (((_height ?? 0) * Conversion.meterToInch.value) %
                Conversion.feetToInch.value)
            .toInt();
        return _height != null
            ? (unit: feet, subunit: inches)
            : (unit: 5, subunit: 6);
    }
  }

  String get heightDescription {
    ({int unit, int subunit}) height = heightInMeasurementSystem;
    switch (heightUnit) {
      case MeasurementSystem.metric:
        return '${height.unit}m ${height.subunit}cm';
      default:
        return '${height.unit}\' ${height.subunit}"';
    }
  }

  @JsonKey(includeFromJson: true, includeToJson: true)
  CalorieDeficit _calorieDeficit;

  @JsonKey(includeFromJson: true, includeToJson: true)
  PassioMealPlan? _mealPlan;

  void setPassioMealPlan(PassioMealPlan mealPlan) {
    _mealPlan = mealPlan;
    setCarbsPercentage(mealPlan.carbTarget);
    setProteinPercentage(mealPlan.proteinTarget);
    setFatPercentage(mealPlan.fatTarget);
  }

  PassioMealPlan? getPassioMealPlan() => _mealPlan;

  void setCalorieDeficit(CalorieDeficit calorieDeficit) {
    if (_calorieDeficit == calorieDeficit) return;
    _calorieDeficit = calorieDeficit;
    int calories = _calculateRecommendedCalorie();
    if (calories > 0) {
      caloriesTarget = calories;
    }
  }

  CalorieDeficit getCalorieDeficit() => _calorieDeficit;

  int caloriesTarget = 2100;

  int get recommendedCalories => _calculateRecommendedCalorie();

  // Carbs
  int carbsPercentage = 50;

  int get carbsGram => caloriesTarget * carbsPercentage / 100 ~/ 4;

  void setCarbsPercentage(int carbs) {
    final values = (balance3Values(
        first: carbs, second: proteinPercentage, third: fatPercentage));
    carbsPercentage = values.$1;
    proteinPercentage = values.$2;
    fatPercentage = values.$3;
  }

  int proteinPercentage = 25;

  int get proteinGram => caloriesTarget * proteinPercentage / 100 ~/ 4;

  void setProteinPercentage(int protein) {
    final values = (balance3Values(
        first: protein, second: fatPercentage, third: carbsPercentage));
    proteinPercentage = values.$1;
    fatPercentage = values.$2;
    carbsPercentage = values.$3;
  }

  int fatPercentage = 25;

  int get fatGram => caloriesTarget * fatPercentage / 100 ~/ 9;

  void setFatPercentage(int fat) {
    final values = (balance3Values(
        first: fat, second: proteinPercentage, third: carbsPercentage));
    fatPercentage = values.$1;
    proteinPercentage = values.$2;
    carbsPercentage = values.$3;
  }

  (int, int, int) balance3Values(
      {required int first, required int second, required int third}) {
    final validateFirst = _validatePercent(value: first);
    if ((validateFirst + third) > 100) {
      return (validateFirst, 0, 100 - validateFirst);
    } else {
      return (validateFirst, 100 - validateFirst - third, third);
    }
  }

  int _validatePercent({required int value}) {
    return switch (value) {
      > 100 => 100,
      < 0 => 0,
      _ => value,
    };
  }

  /// Function to calculate Basal Metabolic Rate (BMR)
  ({double? bmr, ActivityLevel? activityLevel}) _calculateBMR() {
    if (_activityLevel == null ||
        _age == null ||
        _height == null ||
        _weight == null) return (bmr: null, activityLevel: null);
    double bmr = 0;
    double heightInMeter = _height! * Conversion.centiMeterToMeter.value;
    // Calculate weight in kilograms
    double weightInKg = 10 * _weight!;
    // Calculate BMR based on gender
    bmr = switch (gender) {
      GenderSelection.male => weightInKg +
          (6.25 * heightInMeter) -
          (5 * _age!) +
          5, // Formula for BMR calculation for males
      _ => weightInKg +
          (6.25 * heightInMeter) -
          (5 * _age!) -
          161, // Formula for BMR calculation for females
    };
    return (bmr: bmr, activityLevel: _activityLevel);
  }

  int _calculateCaloriesBasedOnActivityLevel() {
    final bmr = _calculateBMR();
    if (bmr.bmr == null) return 0;
    return switch (bmr.activityLevel) {
      ActivityLevel.notActive => ((bmr.bmr!) * 1.2).toInt(),
      ActivityLevel.lightlyActive => ((bmr.bmr!) * 1.375).toInt(),
      ActivityLevel.moderatelyActive => ((bmr.bmr!) * 1.55).toInt(),
      ActivityLevel.active => ((bmr.bmr!) * 1.725).toInt(),
      _ => 2100,
    };
  }

  int _calculateRecommendedCalorie() {
    int calories = _calculateCaloriesBasedOnActivityLevel();
    return switch (_calorieDeficit) {
      CalorieDeficit.lose0_5 => calories -= 250,
      CalorieDeficit.lose1_0 => calories -= 500,
      CalorieDeficit.lose1_5 => calories -= 750,
      CalorieDeficit.lose2_0 => calories -= 1000,
      CalorieDeficit.gain0_5 => calories += 250,
      CalorieDeficit.gain1_0 => calories += 500,
      CalorieDeficit.gain1_5 => calories += 750,
      CalorieDeficit.gain2_0 => calories += 1000,
      CalorieDeficit.maintainWeight => calories += 0,
    };
  }

  double? get bmi {
    if (_weight != null &&
        (_weight ?? 0) > 0 &&
        _height != null &&
        (_height ?? 0) > 0) {
      return ((_weight ?? 0) / pow((_height ?? 0), 2)).parseFormatted();
    }
    return null;
  }

  String get bmiDescription {
    return switch (bmi ?? 0) {
      < 18.5 => 'Underweight',
      >= 18.5 && < 25 => 'Normal',
      >= 25 && < 30 => 'Overweight',
      _ => 'Obese',
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserProfileModel &&
        other.id == id &&
        other.name == name &&
        other._age == _age &&
        other.gender == gender &&
        other._weight == _weight &&
        other._height == _height &&
        other.heightUnit == heightUnit &&
        other.weightUnit == weightUnit &&
        other._targetWeight == _targetWeight &&
        other._targetWater == _targetWater &&
        other._activityLevel == _activityLevel &&
        other._calorieDeficit == _calorieDeficit;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        _age,
        gender,
        _weight,
        _height,
        heightUnit,
        weightUnit,
        _targetWeight,
        _targetWater,
        _activityLevel,
        _calorieDeficit,
      );

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}
