import 'package:nutrition_ai/nutrition_ai.dart';

extension UnitExtension on Unit {
  Unit convertBasedOn(UnitMass targetWeight, UnitMass currentWeight) {
    return this * (targetWeight.value / currentWeight.value);
  }
}
