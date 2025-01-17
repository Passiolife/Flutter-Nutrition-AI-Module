import 'package:flutter/material.dart';

import '../../../../common/models/food_record/food_record.dart';

class EditNutritionFactsNavigationDataProvider extends InheritedWidget {
  const EditNutritionFactsNavigationDataProvider({
    super.key,
    required this.foodRecord,
    required this.index,
    required super.child,
  });

  final FoodRecord foodRecord;
  final int? index;

  @override
  bool updateShouldNotify(EditNutritionFactsNavigationDataProvider oldWidget) {
    return foodRecord != oldWidget.foodRecord && index != oldWidget.index;
  }


  static EditNutritionFactsNavigationDataProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<EditNutritionFactsNavigationDataProvider>();
  }


  static EditNutritionFactsNavigationDataProvider of(BuildContext context) {
    final provider = maybeOf(context);
    assert(provider != null, 'No NavigationDataProvider found in context');
    return provider!;
  }
}
