import '../../../../../../nutrition_ai_module.dart';

class Nutrient {
  final String value;
  final String label;
  final UnitMassType type;

  const Nutrient({
    required this.value,
    required this.label,
    required this.type,
  });

  Nutrient copyWith(
      {String? value, String? label, UnitMassType? type, Unit? unit}) {
    return Nutrient(
      value: value ?? this.value,
      label: label ?? this.label,
      type: type ?? this.type,
    );
  }

  UnitMass? toUnitMass() {
    final parsedValue = double.tryParse(value);
    if (parsedValue != null) {
      return UnitMass(parsedValue, type);
    }
    return null;
  }
}
