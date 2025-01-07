import 'dart:io';

import 'package:flutter/material.dart';

class NavigationDataProvider extends InheritedWidget {
  const NavigationDataProvider({
    required this.file,
    required super.child,
    super.key,
  });

  final File file;

  @override
  bool updateShouldNotify(NavigationDataProvider oldWidget) {
    return file != oldWidget.file;
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
