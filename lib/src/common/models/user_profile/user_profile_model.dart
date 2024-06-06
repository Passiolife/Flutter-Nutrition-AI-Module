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

/// Represents units for weight measurements.
enum WeightUnits {
  /// Pounds (lbs).
  lbs,

  /// Kilograms (kg).
  kg,
}

/// Represents units for water volume measurements.
enum WaterUnits {
  /// Ounces (oz).
  oz,

  /// Milliliters (ml).
  ml,
}

/// Represents units for height measurements.
enum HeightUnit {
  /// Meters (m).
  meter,

  /// Centimeters (cm).
  centimeter,

  /// Feet (ft).
  feet,

  /// Inches (in).
  inches,
}

/// Represents the gender selection options.
enum GenderSelection {
  /// Male gender.
  male,

  /// Female gender.
  female,
}

// Define an enum to represent different conversion factors
enum Conversion {
  /// Conversion factor from centimeters to meters.
  centiMeterToMeter(100),

  /// Conversion factor from meters to inches.
  meterToInch(39.3701),

  /// Conversion factor from feet to inches.
  feetToInch(12),

  /// Conversion factor from kilograms to pounds.
  kgToLbs(2.2046),

  /// Conversion factor from milliliters to ounces.
  mlToOz(0.0338);

  /// The value of the conversion factor.
  final double value;

  // Constructor to initialize the value of each conversion factor
  const Conversion(this.value);
}

/// Represents different levels of activity.
enum ActivityLevel {
  /// Not active.
  notActive,

  /// Lightly active.
  lightlyActive,

  /// Moderately active.
  moderatelyActive,

  /// Very active.
  active;
}

/// Represents different options for calorie deficit or surplus.
enum CalorieDeficit {
  /// Lose 0.5 lbs per week.
  lose0_5(0.5),

  /// Lose 1.0 lbs per week.
  lose1_0(1.0),

  /// Lose 1.5 lbs per week.
  lose1_5(1.5),

  /// Lose 2.0 lbs per week.
  lose2_0(2.0),

  /// Gain 0.5 lbs per week.
  gain0_5(0.5),

  /// Gain 1.0 lbs per week.
  gain1_0(1.0),

  /// Gain 1.5 lbs per week.
  gain1_5(1.5),

  /// Gain 2.0 lbs per week.
  gain2_0(2.0),

  /// Maintain current weight (no deficit or surplus).
  maintainWeight(0);

  /// The value of the calorie deficit or surplus.
  final double value;

  /// Constructor to initialize the value of each calorie deficit or surplus.
  const CalorieDeficit(this.value);

  /// Get the value of the calorie deficit or surplus based on the provided measurement system.
  double getValue(MeasurementSystem unit) {
    return (unit == MeasurementSystem.imperial)
        ? value
        : value / Conversion.kgToLbs.value;
  }
}

/// A class representing a user's profile model.
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

  /// Unique identifier for the user profile.
  String? id;

  /// Name of the user.
  String? name;

  // Age
  @JsonKey(includeFromJson: true, includeToJson: true)
  int? _age;

  /// Set the age of the user.
  void setAge(int? age) {
    if (_age == age) return;
    _age = age;
    int calories = _calculateRecommendedCalorie();
    if (calories > 0) {
      caloriesTarget = calories;
    }
  }

  /// Get the age of the user.
  int? getAge() => _age;

  // Weight
  @JsonKey(includeFromJson: true, includeToJson: true)
  double? _weight;

  /// Set the weight of the user.
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

  /// Get the weight of the user.
  double? getWeight() {
    if (_weight != null) {
      return switch (weightUnit) {
        MeasurementSystem.imperial => (_weight ?? 0) * Conversion.kgToLbs.value,
        _ => _weight,
      };
    }
    return null;
  }

  /// Stores the target weight
  @JsonKey(includeFromJson: true, includeToJson: true)
  double _targetWeight;

  /// Sets the target weight based on the provided weight and the current measurement system.
  void setTargetWeight(double weight) {
    _targetWeight = switch (weightUnit) {
      // If the measurement system is imperial, convert weight to kilograms.
      MeasurementSystem.imperial => weight / Conversion.kgToLbs.value,
      // If the measurement system is metric, keep weight as it is.
      _ => weight,
    };
  }

  /// Gets the target weight based on the current measurement system.
  double? getTargetWeight() {
    return switch (weightUnit) {
      // If the measurement system is imperial, convert weight back to pounds.
      MeasurementSystem.imperial => _targetWeight * Conversion.kgToLbs.value,
      // If the measurement system is metric, return the weight as it is.
      _ => _targetWeight,
    };
  }

  GenderSelection gender;
  MeasurementSystem heightUnit;
  MeasurementSystem weightUnit;

  /// Stores the target water volume.
  @JsonKey(includeFromJson: true, includeToJson: true)
  double _targetWater;

  /// Sets the target water volume based on the provided volume and the current measurement system.
  void setTargetWater(double water) {
    _targetWater = switch (weightUnit) {
      // If the measurement system is imperial, convert water volume to ounces.
      MeasurementSystem.imperial => water / Conversion.mlToOz.value,
      // If the measurement system is metric, keep water volume as it is.
      _ => water,
    };
  }

  /// Gets the target water volume based on the current measurement system.
  double? getTargetWater() {
    return switch (weightUnit) {
      // If the measurement system is imperial, convert water volume back to milliliters and format the result.
      MeasurementSystem.imperial =>
        (_targetWater * Conversion.mlToOz.value).parseFormatted(),
      // If the measurement system is metric, return the water volume as it is and format the result.
      _ => _targetWater.parseFormatted(),
    };
  }

  // Stores the user's activity level.
  @JsonKey(includeFromJson: true, includeToJson: true)
  ActivityLevel? _activityLevel;

  /// Sets the user's activity level and updates the recommended calorie target if needed.
  void setActivityLevel(ActivityLevel? activityLevel) {
    // If the new activity level is the same as the current one, do nothing.
    if (_activityLevel == activityLevel) return;
    // Set the new activity level.
    _activityLevel = activityLevel;
    // Recalculate the recommended calorie target.
    int calories = _calculateRecommendedCalorie();
    if (calories > 0) {
      // Update the calorie target if it's positive.
      caloriesTarget = calories;
    }
  }

  /// Gets the user's activity level.
  ActivityLevel? getActivityLevel() => _activityLevel;

  /// Stores the user's height.
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

  /// Gets the user's height.
  double? getHeight() => _height;

  /// Gets the height in the specified measurement system.
  /// Returns a tuple containing the unit and subunit (e.g., unit = meters, subunit = centimeters for metric).
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

  /// Gets the description of the user's height based on the measurement system.
  String get heightDescription {
    ({int unit, int subunit}) height = heightInMeasurementSystem;
    switch (heightUnit) {
      case MeasurementSystem.metric:
        return '${height.unit}m ${height.subunit}cm';
      default:
        return '${height.unit}\' ${height.subunit}"';
    }
  }

  /// Stores the user's selected calorie deficit.
  @JsonKey(includeFromJson: true, includeToJson: true)
  CalorieDeficit _calorieDeficit;

  /// Sets the user's selected calorie deficit and updates the recommended calorie target if needed.
  void setCalorieDeficit(CalorieDeficit calorieDeficit) {
    // If the new calorie deficit is the same as the current one, do nothing.
    if (_calorieDeficit == calorieDeficit) return;
    // Set the new calorie deficit.
    _calorieDeficit = calorieDeficit;
    // Recalculate the recommended calorie target.
    int calories = _calculateRecommendedCalorie();
    if (calories > 0) {
      // Update the calorie target if it's positive.
      caloriesTarget = calories;
    }
  }

  /// Gets the user's selected calorie deficit.
  CalorieDeficit getCalorieDeficit() => _calorieDeficit;

  /// Stores the user's meal plan.
  @JsonKey(includeFromJson: true, includeToJson: true)
  PassioMealPlan? _mealPlan;

  /// Sets the user's meal plan and updates the nutrient percentages accordingly.
  void setPassioMealPlan(PassioMealPlan mealPlan) {
    // Set the new meal plan.
    _mealPlan = mealPlan;
    // Update the nutrient percentages based on the meal plan targets.
    setCarbsPercentage(mealPlan.carbTarget);
    setProteinPercentage(mealPlan.proteinTarget);
    setFatPercentage(mealPlan.fatTarget);
  }

  /// Gets the user's meal plan.
  PassioMealPlan? getPassioMealPlan() => _mealPlan;

  /// Stores the target daily calorie intake.
  int caloriesTarget = 2100;

  /// Gets the recommended daily calorie intake based on the user's profile.
  int get recommendedCalories => _calculateRecommendedCalorie();

  /// Stores the percentage of carbohydrates in the diet.
  int carbsPercentage = 50;

  /// Calculates the total grams of carbohydrates based on the percentage and total calorie target.
  int get carbsGram => caloriesTarget * carbsPercentage / 100 ~/ 4;

  /// Sets the percentage of carbohydrates in the diet and adjusts other nutrient percentages to maintain balance.
  void setCarbsPercentage(int carbs) {
    final values = (balance3Values(
        first: carbs, second: proteinPercentage, third: fatPercentage));
    // Set the new percentage of carbohydrates.
    carbsPercentage = values.$1;
    // Set the adjusted percentage of protein.
    proteinPercentage = values.$2;
    // Set the adjusted percentage of fat.
    fatPercentage = values.$3;
  }

  /// Stores the percentage of protein in the diet.
  int proteinPercentage = 25;

  /// Calculates the total grams of protein based on the percentage and total calorie target.
  int get proteinGram => caloriesTarget * proteinPercentage / 100 ~/ 4;

  /// Sets the percentage of protein in the diet and adjusts other nutrient percentages to maintain balance.
  void setProteinPercentage(int protein) {
    final values = (balance3Values(
        first: protein, second: fatPercentage, third: carbsPercentage));
    // Set the new percentage of protein.
    proteinPercentage = values.$1;
    // Set the adjusted percentage of fat.
    fatPercentage = values.$2;
    // Set the adjusted percentage of carbohydrates.
    carbsPercentage = values.$3;
  }

  /// Stores the percentage of fat in the diet.
  int fatPercentage = 25;

  /// Calculates the total grams of fat based on the percentage and total calorie target.
  int get fatGram => caloriesTarget * fatPercentage / 100 ~/ 9;

  /// Sets the percentage of fat in the diet and adjusts other nutrient percentages to maintain balance.
  void setFatPercentage(int fat) {
    final values = (balance3Values(
        first: fat, second: proteinPercentage, third: carbsPercentage));
    // Set the new percentage of fat.
    fatPercentage = values.$1;
    // Set the adjusted percentage of protein.
    proteinPercentage = values.$2;
    // Set the adjusted percentage of carbohydrates.
    carbsPercentage = values.$3;
  }

  /// Balances three values ensuring they sum up to 100.
  ///
  /// This function adjusts the first value to ensure that the sum of all three values is 100.
  /// If the sum of the first and third values exceeds 100, the third value is set to 0 and the remaining percentage is distributed between the first and second values.
  /// If the sum is less than 100, the remaining percentage is assigned to the second value.
  ///
  /// Returns a tuple containing the balanced values.
  (int, int, int) balance3Values(
      {required int first, required int second, required int third}) {
    // Validate the first value.
    final validateFirst = _validatePercent(value: first);
    if ((validateFirst + third) > 100) {
      // If the sum of the first and third values exceeds 100, adjust the values.
      return (validateFirst, 0, 100 - validateFirst);
    } else {
      // If the sum is less than 100, adjust the values accordingly.
      return (validateFirst, 100 - validateFirst - third, third);
    }
  }

  /// Validates a percentage value to ensure it falls within the range of 0 to 100.
  ///
  /// If the value is greater than 100, it's capped at 100.
  /// If the value is less than 0, it's set to 0.
  ///
  /// Returns the validated percentage value.
  int _validatePercent({required int value}) {
    return switch (value) {
      // If the value is greater than 100, return 100.
      > 100 => 100,
      // If the value is less than 0, return 0.
      < 0 => 0,
      // Otherwise, return the value as is.
      _ => value,
    };
  }

  /// Calculates Basal Metabolic Rate (BMR) and activity-adjusted calorie intake based on user profile.
  ///
  /// This function calculates the BMR using the Harris-Benedict equation and adjusts it based on the user's activity level.
  /// It then further adjusts the calorie intake based on the desired calorie deficit or surplus.
  ///
  /// Returns a tuple containing BMR and activity level.
  ({double? bmr, ActivityLevel? activityLevel}) _calculateBMR() {
    if (_activityLevel == null ||
        _age == null ||
        _height == null ||
        _weight == null) {
      // Return null if essential profile data is missing.
      return (bmr: null, activityLevel: null);
    }

    // Initialize BMR variable.
    double bmr = 0;
    // Convert height to meters.
    double heightInMeter = _height! * Conversion.centiMeterToMeter.value;
    // Calculate weight in kilograms
    double weightInKg = 10 * _weight!;
    // Calculate BMR based on gender using the Harris-Benedict equation.
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
    // Return calculated BMR and activity level.
    return (bmr: bmr, activityLevel: _activityLevel);
  }

  /// Calculates the total calorie intake based on BMR and activity level.
  int _calculateCaloriesBasedOnActivityLevel() {
    // Calculate BMR.
    final bmr = _calculateBMR();

    if (bmr.bmr == null) return 0; // Return 0 if BMR is null.

    // Adjust BMR based on activity level.
    return switch (bmr.activityLevel) {
      ActivityLevel.notActive => ((bmr.bmr!) * 1.2).toInt(),
      ActivityLevel.lightlyActive => ((bmr.bmr!) * 1.375).toInt(),
      ActivityLevel.moderatelyActive => ((bmr.bmr!) * 1.55).toInt(),
      ActivityLevel.active => ((bmr.bmr!) * 1.725).toInt(),
      _ => 2100, // Default calorie intake.
    };
  }

  /// Calculates the recommended daily calorie intake based on user profile and desired calorie deficit or surplus.
  int _calculateRecommendedCalorie() {
    // Get calorie intake based on activity level.
    int calories = _calculateCaloriesBasedOnActivityLevel();
    return switch (_calorieDeficit) {
      CalorieDeficit.lose0_5 => calories -=
          250, // Reduce calories by 250 for a deficit of 0.5 kg per week.
      CalorieDeficit.lose1_0 => calories -=
          500, // Reduce calories by 500 for a deficit of 1 kg per week.
      CalorieDeficit.lose1_5 => calories -=
          750, // Reduce calories by 750 for a deficit of 1.5 kg per week.
      CalorieDeficit.lose2_0 => calories -=
          1000, // Reduce calories by 1000 for a deficit of 2 kg per week.
      CalorieDeficit.gain0_5 => calories +=
          250, // Increase calories by 250 for a surplus of 0.5 kg per week.
      CalorieDeficit.gain1_0 => calories +=
          500, // Increase calories by 500 for a surplus of 1 kg per week.
      CalorieDeficit.gain1_5 => calories +=
          750, // Increase calories by 750 for a surplus of 1.5 kg per week.
      CalorieDeficit.gain2_0 => calories +=
          1000, // Increase calories by 1000 for a surplus of 2 kg per week.
      CalorieDeficit.maintainWeight => calories +=
          0, // Maintain current weight.
    };
  }

  /// Calculates Body Mass Index (BMI) based on weight and height.
  double? get bmi {
    if (_weight != null &&
        (_weight ?? 0) > 0 &&
        _height != null &&
        (_height ?? 0) > 0) {
      // Calculate BMI using weight (kg) divided by height squared (m^2).
      return ((_weight ?? 0) / pow((_height ?? 0), 2)).parseFormatted();
    }
    // Return null if weight or height is missing or invalid.
    return null;
  }

  /// Returns a description of BMI category based on calculated BMI value.
  String get bmiDescription {
    return switch (bmi ?? 0) {
      < 18.5 => 'Underweight', // BMI less than 18.5 indicates underweight.
      >= 18.5 && < 25 =>
        'Normal', // BMI between 18.5 and 24.9 indicates normal weight.
      >= 25 && < 30 =>
        'Overweight', // BMI between 25 and 29.9 indicates overweight.
      _ => 'Obese', // BMI of 30 or greater indicates obesity.
    };
  }

  /// Overrides the equality operator.
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

  /// Overrides the hashCode method.
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

  /// Constructs a [UserProfileModel] instance from a JSON map.
  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  /// Converts the [UserProfileModel] instance to a JSON map.
  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}
