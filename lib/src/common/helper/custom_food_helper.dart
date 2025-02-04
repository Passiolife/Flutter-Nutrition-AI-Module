import 'package:nutrition_ai/nutrition_ai.dart';

import '../extension/core_extension.dart';
import '../models/food_record/food_record.dart';

class CustomFoodHelper {
  static String generateIconId() {
    return '${FoodRecord.userFoodPrefix}${DateTime.now().millisecondsSinceEpoch}';
  }

  static String defaultServingUnit = 'serving';

  static List<PassioServingUnit> getDefaultServingUnits() =>
      _defaultServingUnits;
  static final List<PassioServingUnit> _defaultServingUnits = [
    PassioServingUnit('serving', UnitMass(1, UnitMassType.grams)),
    PassioServingUnit('gram', UnitMass(1, UnitMassType.grams)),
  ];

  static List<String> getServingUnitNames({String? unit}) {
    final names = [
      'serving',
      'piece',
      'small',
      'medium',
      'large',
      'cup',
      'oz',
      'gram',
      'ml',
      'handful',
      'scoop',
      'tbsp',
      'tsp',
      'slice',
      'can',
      'bottle',
      'bar',
      'packet',
    ];

    if (unit.isNotNullOrEmpty == true && !names.contains(unit)) {
      names.insert(0, unit!);
    }

    return names;
  }


  static List<PassioServingSize> getDefaultServingSizes() =>
      _defaultServingSizes;
  static final List<PassioServingSize> _defaultServingSizes = [
    PassioServingSize(1, 'serving'),
    PassioServingSize(100, 'gram'),
  ];

  static List<PassioServingUnit> generateCustomServingUnits(
    String? selectedUnit,
    double? weight,
  ) {
    return [
      if (selectedUnit != null && weight != null && selectedUnit != 'gram')
        PassioServingUnit(selectedUnit, UnitMass(weight, UnitMassType.grams)),
      PassioServingUnit('gram', UnitMass(1, UnitMassType.grams)),
    ];
  }

  static List<PassioServingSize> generateCustomServingSizes(
      String? selectedUnit) {
    return [
      if (selectedUnit != null && selectedUnit != 'gram')
        PassioServingSize(1, selectedUnit),
      PassioServingSize(100, 'gram'),
    ];
  }
}
