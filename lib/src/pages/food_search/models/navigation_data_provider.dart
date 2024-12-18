import 'package:flutter/material.dart';

class SearchNavigationDataProvider extends InheritedWidget {
  const SearchNavigationDataProvider({
    required this.needsReturn,
    required super.child,
    super.key,
  });

  final bool needsReturn;

  @override
  bool updateShouldNotify(SearchNavigationDataProvider oldWidget) {
    return needsReturn != oldWidget.needsReturn;
  }

  static SearchNavigationDataProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SearchNavigationDataProvider>();
  }

  static SearchNavigationDataProvider of(BuildContext context) {
    final widget = maybeOf(context);
    assert(widget != null, 'No NavigationDataProvider found in context');
    return widget!;
  }
}
