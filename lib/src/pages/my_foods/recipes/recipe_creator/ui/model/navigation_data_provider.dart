import 'package:flutter/material.dart';

import '../../../../../../common/models/food_record/food_record.dart';

class NavigationData {
  final bool logUponCreate;
  final FoodRecord? loggedFoodRecord;
  final FoodRecord? recipeFoodRecord;

  const NavigationData({
    this.logUponCreate = false,
    this.loggedFoodRecord,
    this.recipeFoodRecord,
  });
}

class NavigationDataProvider extends InheritedWidget {
  const NavigationDataProvider({
    required this.params,
    required super.child,
    super.key,
  });

  final NavigationData params;
  // final bool logUponCreate;
  // final FoodRecord? loggedFoodRecord;
  // final FoodRecord? recipeFoodRecord;

  @override
  bool updateShouldNotify(NavigationDataProvider oldWidget) {
    return params != oldWidget.params;
    /*return logUponCreate != oldWidget.logUponCreate ||
        loggedFoodRecord != oldWidget.loggedFoodRecord ||
        recipeFoodRecord != oldWidget.recipeFoodRecord;*/
  }

  static NavigationDataProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NavigationDataProvider>();
  }

  static NavigationDataProvider of(BuildContext context) {
    final widget = maybeOf(context);
    assert(widget != null, 'No NavigationDataProvider found in context');
    return widget!;
  }
}
