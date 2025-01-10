import 'package:flutter/material.dart';

import '../constant/app_theme.dart';
import '../locale/app_localizations.dart';

extension Util on BuildContext {
  MediaQueryData get info => MediaQuery.of(this);

  EdgeInsets get padding => MediaQuery.paddingOf(this);
}

extension Dimension on BuildContext {
  double get height => info.size.height;

  double get width => info.size.width;

  bool get isKeyboardVisible => info.viewInsets.bottom != 0.0;

  double get keyboardHeightValue => info.viewInsets.bottom;
  EdgeInsets get keyboardHeight => EdgeInsets.only(bottom: keyboardHeightValue);

  double get topPadding => padding.top;

  double get bottomPaddingValue => info.padding.bottom;

  EdgeInsets get bottomPadding => EdgeInsets.only(bottom: bottomPaddingValue);

  double get safeAreaPadding => topPadding + bottomPaddingValue;

  /// [localization] is use to get the locale string.
  AppLocalizations get localization => AppLocalizations.instance;
}

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  ColorScheme get colorScheme => theme.colorScheme;

  AppThemeColors get themeColors => theme.extension<AppThemeColors>()!;

  AppTextThemeColors get textThemeColors =>
      theme.extension<AppTextThemeColors>()!;

  AppIconThemeColors get iconThemeColors =>
      theme.extension<AppIconThemeColors>()!;
}
