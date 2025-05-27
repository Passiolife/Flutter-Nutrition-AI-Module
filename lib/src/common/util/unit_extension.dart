import 'package:nutrition_ai/nutrition_ai.dart';

extension UnitExtension on Unit {
  Unit convertBasedOn(UnitMass targetWeight, UnitMass currentWeight) {
    if(this is UnitMass) {
      return (this as UnitMass) * (targetWeight.value / currentWeight.value);
    } else if(this is UnitEnergy) {
      return (this as UnitEnergy) * (targetWeight.value / currentWeight.value);
    }
    return UnitMass(0, UnitMassType.grams);
  }
}
