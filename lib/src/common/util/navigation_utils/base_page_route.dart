import 'package:flutter/material.dart';

class BasePageRoute<T> extends PageRouteBuilder<T> {

  final Widget child;
  final Curve curve;

  BasePageRoute({
    required this.child,
    this.curve = Curves.easeInOut,
    Duration transitionDuration = const Duration(milliseconds: 300),
    Duration reverseTransitionDuration = const Duration(milliseconds: 300),
    RouteSettings? settings,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => child,
          transitionDuration: transitionDuration,
          reverseTransitionDuration: reverseTransitionDuration,
          settings: settings,
        );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // Default behavior: no animation
    return child;
  }
}
