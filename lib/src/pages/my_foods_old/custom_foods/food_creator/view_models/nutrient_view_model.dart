import '../../../../../../nutrition_ai_module.dart';

class NutrientViewModel {
  final String value;
  final String label;
  final UnitMassType type;

  const NutrientViewModel({
    required this.value,
    required this.label,
    required this.type,
  });

  NutrientViewModel copyWith({
    String? value,
    String? label,
    UnitMassType? type,
  }) {
    return NutrientViewModel(
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
