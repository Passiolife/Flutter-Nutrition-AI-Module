part of '../edit_food_page.dart';

class NavigationDataProvider extends InheritedWidget {
  const NavigationDataProvider({
    super.key,
    required this.params,
    required super.child,
  });

  final EditFoodPageParams params;

  @override
  bool updateShouldNotify(NavigationDataProvider oldWidget) {
    return params != oldWidget.params;
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
