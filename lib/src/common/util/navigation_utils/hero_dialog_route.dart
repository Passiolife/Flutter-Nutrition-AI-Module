import 'package:flutter/material.dart';

import 'base_page_route.dart';

class HeroDialogRoute<T> extends BasePageRoute<T> {
  HeroDialogRoute({
    required Widget child,
    Curve curve = Curves.easeInOut,
    Duration transitionDuration = const Duration(milliseconds: 300),
    Duration reverseTransitionDuration = const Duration(milliseconds: 300),
    RouteSettings? settings,
    bool opaque = true,
    bool barrierDismissible = false,
    Color? barrierColor,
  }) : super(
    child: child,
    curve: curve,
    transitionDuration: transitionDuration,
    reverseTransitionDuration: reverseTransitionDuration,
    settings: settings,
    opaque: opaque,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
  );

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return new FadeTransition(
        opacity: new CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child);
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  @override
  String? get barrierLabel => '';
}
/*

class HeroDialogRoute<T> extends BasePageRoute<T> {
  HeroDialogRoute({
    required Widget child,
    Curve curve = Curves.easeInOut,
    Duration transitionDuration = const Duration(milliseconds: 300),
    Duration reverseTransitionDuration = const Duration(milliseconds: 300),
    RouteSettings? settings,
    bool opaque = true,
    bool barrierDismissible = false,
    Color? barrierColor,
  }) : super(
          child: child,
          curve: curve,
          transitionDuration: transitionDuration,
          reverseTransitionDuration: reverseTransitionDuration,
          settings: settings,
          opaque: opaque,
          barrierDismissible: barrierDismissible,
          barrierColor: barrierColor,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: child,
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }
}
*/
