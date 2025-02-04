import 'dart:typed_data';

import 'package:flutter/material.dart';

class TakePhotoResultNavigationDataProvider extends InheritedWidget {
  const TakePhotoResultNavigationDataProvider({
    required this.capturedImages,
    required super.child,
    super.key,
  });

  final List<Uint8List>? capturedImages;

  @override
  bool updateShouldNotify(TakePhotoResultNavigationDataProvider oldWidget) {
    return capturedImages != oldWidget.capturedImages;
  }

  static TakePhotoResultNavigationDataProvider? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TakePhotoResultNavigationDataProvider>();
  }

  static TakePhotoResultNavigationDataProvider of(BuildContext context) {
    final widget = maybeOf(context);
    assert(widget != null, 'No NavigationDataProvider found in context');
    return widget!;
  }
}
