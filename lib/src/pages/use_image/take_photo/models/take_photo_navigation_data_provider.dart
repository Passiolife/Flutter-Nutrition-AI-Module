import 'package:flutter/material.dart';

class TakePhotoNavigationDataProvider extends InheritedWidget {
  const TakePhotoNavigationDataProvider({
    required this.returnResult,
    required this.maxLimit,
    required super.child,
    super.key,
  });

  final bool returnResult;
  final int maxLimit;

  @override
  bool updateShouldNotify(TakePhotoNavigationDataProvider oldWidget) {
    return returnResult != oldWidget.returnResult && maxLimit != oldWidget.maxLimit;
  }

  static TakePhotoNavigationDataProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TakePhotoNavigationDataProvider>();
  }

  static TakePhotoNavigationDataProvider of(BuildContext context) {
    final widget = maybeOf(context);
    assert(widget != null, 'No NavigationDataProvider found in context');
    return widget!;
  }
}
