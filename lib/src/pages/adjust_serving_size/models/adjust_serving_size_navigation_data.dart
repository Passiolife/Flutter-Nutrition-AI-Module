import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../common/models/food_record/food_record.dart';

class AdjustServingSizeNavigationDataProvider extends InheritedWidget {
  const AdjustServingSizeNavigationDataProvider({
    required this.foodRecord,
    this.index,
    this.image,
    this.onTapEditing,
    required super.child,
    super.key,
  });

  final FoodRecord foodRecord;
  final Uint8List? image;
  final int? index;
  final VoidCallback? onTapEditing;

  @override
  bool updateShouldNotify(AdjustServingSizeNavigationDataProvider oldWidget) {
    return foodRecord != oldWidget.foodRecord && index != oldWidget.index && image != oldWidget.image && onTapEditing != oldWidget.onTapEditing;
  }

  static AdjustServingSizeNavigationDataProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AdjustServingSizeNavigationDataProvider>();
  }

  static AdjustServingSizeNavigationDataProvider of(BuildContext context) {
    final widget = maybeOf(context);
    assert(widget != null, 'No NavigationDataProvider found in context');
    return widget!;
  }
}