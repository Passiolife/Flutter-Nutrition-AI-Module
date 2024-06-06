import 'package:flutter/cupertino.dart';

import '../locale/app_localizations.dart';

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
}
