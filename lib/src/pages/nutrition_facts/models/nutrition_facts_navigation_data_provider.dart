import 'package:flutter/material.dart';

import '../nutrition_facts_page.dart';
import 'nutrition_facts_navigation_data.dart';

class NutritionFactsNavigationDataProvider extends InheritedWidget {
  const NutritionFactsNavigationDataProvider({
    required this.navigationData,
    required super.child,
    super.key,
  });

  final NutritionFactsNavigationData? navigationData;

  @override
  bool updateShouldNotify(NutritionFactsNavigationDataProvider oldWidget) {
    return navigationData != oldWidget.navigationData;
  }

  static NutritionFactsNavigationDataProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NutritionFactsNavigationDataProvider>();
  }

  static NutritionFactsNavigationDataProvider of(BuildContext context) {
    final widget = maybeOf(context);
    assert(widget != null, 'No NutritionFactsNavigationDataProvider found in context');
    return widget!;
  }
}