import 'package:flutter/material.dart';

class ClearFocusOnPushObserver extends NavigatorObserver {
  ClearFocusOnPushObserver();

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    final focus = FocusManager.instance.primaryFocus;
    focus?.unfocus();
  }
}