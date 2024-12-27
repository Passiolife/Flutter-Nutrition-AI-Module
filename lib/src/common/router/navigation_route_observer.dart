import 'package:flutter/material.dart';

class NavigationRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  static final NavigationRouteObserver _instance = NavigationRouteObserver._();

  static NavigationRouteObserver get instance => _instance;

  NavigationRouteObserver._();

  final List<Route> _routeStack = [];

  List<Route> get routeStack => _routeStack;

  @override
  void didPush(Route route, Route? previousRoute) {
    _routeStack.add(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _routeStack.remove(route);
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    _routeStack.remove(route);
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    final index = _routeStack.indexOf(oldRoute!);
    if (index != -1) {
      _routeStack[index] = newRoute!;
    } else {
      _routeStack.add(newRoute!);
    }
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  bool contains(String route) {
    return _routeStack.any((element) => element.settings.name == route);
  }

  Route get currentRoute => _routeStack.last;

  String? get currentRouteName => currentRoute.settings.name;
}
