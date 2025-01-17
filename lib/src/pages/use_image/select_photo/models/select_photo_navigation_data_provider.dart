import 'package:flutter/material.dart';

class SelectPhotoNavigationDataProvider extends InheritedWidget {
  const SelectPhotoNavigationDataProvider({
    required this.returnResult,
    required this.maxLimit,
    required super.child,
    super.key,
  });

  final bool returnResult;
  final int maxLimit;

  @override
  bool updateShouldNotify(SelectPhotoNavigationDataProvider oldWidget) {
    return returnResult != oldWidget.returnResult && maxLimit != oldWidget.maxLimit;
  }

  static SelectPhotoNavigationDataProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SelectPhotoNavigationDataProvider>();
  }

  static SelectPhotoNavigationDataProvider of(BuildContext context) {
    final widget = maybeOf(context);
    assert(widget != null, 'No NavigationDataProvider found in context');
    return widget!;
  }
}
