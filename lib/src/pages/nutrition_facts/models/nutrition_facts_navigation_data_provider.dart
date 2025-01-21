import 'package:flutter/material.dart';

class NutritionFactsNavigationDataProvider extends InheritedWidget {
  const NutritionFactsNavigationDataProvider({
    this.barcode,
    required super.child,
    super.key,
  });

  final String? barcode;

  @override
  bool updateShouldNotify(NutritionFactsNavigationDataProvider oldWidget) {
    return barcode != oldWidget.barcode;
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