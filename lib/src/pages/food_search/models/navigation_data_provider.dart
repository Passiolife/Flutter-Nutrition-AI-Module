import 'package:flutter/material.dart';

import '../../edit_food/ui/edit_food_page.dart';

class SearchNavigationDataProvider extends InheritedWidget {
  const SearchNavigationDataProvider({
    required this.needsReturn,
    this.editFoodPageParams,
    required super.child,
    super.key,
  });

  final bool needsReturn;
  final EditFoodPageParams? editFoodPageParams;

  @override
  bool updateShouldNotify(SearchNavigationDataProvider oldWidget) {
    return needsReturn != oldWidget.needsReturn && editFoodPageParams != oldWidget.editFoodPageParams;
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
