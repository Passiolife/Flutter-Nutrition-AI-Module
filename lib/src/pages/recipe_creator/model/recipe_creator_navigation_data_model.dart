import 'package:flutter/material.dart';

import '../../../common/models/food_record/food_record.dart';

class RecipeCreatorNavigationDataModel extends InheritedWidget {
  const RecipeCreatorNavigationDataModel({
    super.key,
    required super.child,
    required this.logUponCreate,
    this.loggedFoodRecord,
    this.recipeFoodRecord,
  });

  final bool logUponCreate;
  final FoodRecord? loggedFoodRecord;
  final FoodRecord? recipeFoodRecord;

  @override
  bool updateShouldNotify(
      covariant RecipeCreatorNavigationDataModel oldWidget) {
    return logUponCreate != oldWidget.logUponCreate ||
        loggedFoodRecord != oldWidget.loggedFoodRecord ||
        recipeFoodRecord != oldWidget.recipeFoodRecord;
  }

  static RecipeCreatorNavigationDataModel? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<RecipeCreatorNavigationDataModel>();
  }

  static RecipeCreatorNavigationDataModel of(BuildContext context) {
    final provider = maybeOf(context);
    assert(
        provider != null, 'No RecipeCreatorNavigationDataModel found in context');
    return provider!;
  }
}
