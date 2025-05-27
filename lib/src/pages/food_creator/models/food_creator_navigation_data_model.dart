import 'package:flutter/material.dart';

import '../../../common/models/food_record/food_record.dart';

class FoodCreatorNavigationDataModel extends InheritedWidget {
  const FoodCreatorNavigationDataModel({
    super.key,
    required super.child,
    this.index,
    this.foodRecord,
  });

  final int? index;
  final FoodRecord? foodRecord;

  @override
  bool updateShouldNotify(covariant FoodCreatorNavigationDataModel oldWidget) {
    return index != oldWidget.index || foodRecord != oldWidget.foodRecord;
  }

  static FoodCreatorNavigationDataModel? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<FoodCreatorNavigationDataModel>();
  }

  static FoodCreatorNavigationDataModel of(BuildContext context) {
    final provider = maybeOf(context);
    assert(
        provider != null, 'No FoodCreatorNavigationDataModel found in context');
    return provider!;
  }
}
