import 'package:flutter/material.dart';

extension KeyboardExtension on BuildContext {
  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
