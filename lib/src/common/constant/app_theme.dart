import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static final AppTheme _instance = AppTheme._();

  factory AppTheme() {
    return _instance;
  }

  ThemeData get lightTheme {
    return ThemeData.light().copyWith(
      scaffoldBackgroundColor: AppColors.gray50,
      primaryColor: AppColors.indigo600Main,
      primaryColorDark: AppColors.indigo600Dark,
      primaryColorLight: AppColors.indigo600Light,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.indigo600Main,
        onPrimary: AppColors.white,
        secondary: AppColors.indigo100,
        onSecondary: AppColors.indigo100,
        error: AppColors.red500,
        onError: AppColors.white,
        surface: AppColors.white,
        onSurface: AppColors.gray900,
      ),
      extensions: [
        AppThemeColors(
          feedbackErrorColor: AppColors.red600Error,
        ),
        AppTextThemeColors(
          brandTextLight: AppColors.brandTextLight,
          brandTextDark: AppColors.brandTextDark,
          errorColor: AppColors.red600Error,
        ),
      ],
    );
  }
}

/// [AppTextThemeColors] is used to declare color which is random use in app.
class AppTextThemeColors extends ThemeExtension<AppTextThemeColors> {
  final Color? brandTextLight;
  final Color? brandTextDark;
  final Color? errorColor;

  AppTextThemeColors({
    this.brandTextLight,
    this.brandTextDark,
    this.errorColor,
  });

  @override
  ThemeExtension<AppTextThemeColors> copyWith() {
    return AppTextThemeColors(
      brandTextLight: brandTextLight,
      brandTextDark: brandTextDark,
      errorColor: errorColor,
    );
  }

  @override
  ThemeExtension<AppTextThemeColors> lerp(
      covariant ThemeExtension<AppTextThemeColors>? other, double t) {
    if (other is! AppTextThemeColors) {
      return this;
    }
    return AppTextThemeColors(
      brandTextLight: Color.lerp(brandTextLight, other.brandTextLight, t),
      brandTextDark: Color.lerp(brandTextDark, other.brandTextDark, t),
      errorColor: Color.lerp(errorColor, other.errorColor, t),
    );
  }
}

/// [AppThemeColors] is used to declare color which is random use in app.
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  final Color? feedbackErrorColor;

  AppThemeColors({
    required this.feedbackErrorColor,
  });

  @override
  ThemeExtension<AppThemeColors> copyWith() {
    return AppThemeColors(
      feedbackErrorColor: feedbackErrorColor,
    );
  }

  @override
  ThemeExtension<AppThemeColors> lerp(
      covariant ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) {
      return this;
    }
    return AppThemeColors(
      feedbackErrorColor: Color.lerp(feedbackErrorColor, other.feedbackErrorColor, t),
    );
  }
}
