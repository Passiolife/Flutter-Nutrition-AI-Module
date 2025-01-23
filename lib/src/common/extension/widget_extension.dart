import 'package:flutter/material.dart';

extension ConditionalWrapper on Widget {
  Widget wrapIf(bool condition, Widget Function(Widget child) wrapper) {
    if (condition) {
      return wrapper(this);
    }
    return this;
  }
}