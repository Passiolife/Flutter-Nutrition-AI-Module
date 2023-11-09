import 'package:flutter/cupertino.dart';

import '../../locale/app_localizations.dart';

extension Util on BuildContext {
  MediaQueryData get info => MediaQuery.of(this);

  EdgeInsets get padding => MediaQuery.paddingOf(this);
}

extension Dimension on BuildContext {
  double get height => info.size.height;

  double get width => info.size.width;

  bool get isKeyboardVisible => info.viewInsets.bottom != 0.0;

  double get keyboardHeight => info.viewInsets.bottom;

  double get topPadding => padding.top;

  double get bottomPadding => info.padding.bottom;

  double get safeAreaPadding => topPadding + bottomPadding;

  /// [localization] is use to get the locale string.
  AppLocalizations? get localization => AppLocalizations.instance;

  /// [showCupertinoPopup] displays a CupertinoModalPopup with a reasonable fixed height
  /// which hosts CupertinoDatePicker.
  void showCupertinoPopup({required Widget child, required double height, bool barrierDismissible = true, Color? backgroundColor}) {
    showCupertinoModalPopup<void>(
      barrierDismissible: barrierDismissible,
      context: this,
      builder: (BuildContext context) => Container(
        height: height,
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: backgroundColor ?? CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
}
