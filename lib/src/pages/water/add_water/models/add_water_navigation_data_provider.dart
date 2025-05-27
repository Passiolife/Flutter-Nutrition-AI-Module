import 'package:flutter/material.dart';

import '../../../../common/models/water_record/water_record.dart';

class AddWaterNavigationDataProvider extends InheritedWidget {
  const AddWaterNavigationDataProvider({
    this.record,
    required super.child,
    super.key,
  });

  final WaterRecord? record;

  @override
  bool updateShouldNotify(AddWaterNavigationDataProvider oldWidget) {
    return record != oldWidget.record;
  }

  static AddWaterNavigationDataProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AddWaterNavigationDataProvider>();
  }

  static AddWaterNavigationDataProvider of(BuildContext context) {
    final widget = maybeOf(context);
    assert(widget != null, 'No NavigationDataProvider found in context');
    return widget!;
  }
}