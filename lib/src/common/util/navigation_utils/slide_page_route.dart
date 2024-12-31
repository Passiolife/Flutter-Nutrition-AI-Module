import 'package:flutter/material.dart';

import 'base_page_route.dart';

class SlidePageRoute<T> extends BasePageRoute<T> {
  SlidePageRoute({
    required Widget child,
    Curve curve = Curves.easeInOut,
    Duration transitionDuration = const Duration(milliseconds: 300),
    Duration reverseTransitionDuration = const Duration(milliseconds: 300),
    RouteSettings? settings,
  }) : super(
          child: child,
          curve: curve,
          transitionDuration: transitionDuration,
          reverseTransitionDuration: reverseTransitionDuration,
          settings: settings,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    const begin = Offset(1.0, 0.0);
    const end = Offset.zero;
    final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}
