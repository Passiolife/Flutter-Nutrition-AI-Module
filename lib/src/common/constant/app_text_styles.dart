import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_dimens.dart';

class AppTextStyle {
  // Font family for the entire app
  static const String _fontFamily = 'Inter';

  // Function to generate a TextStyle with the specified font size
  static TextStyle _getTextStyle(double fontSize, double lineHeight) {
    return TextStyle(
        fontFamily: _fontFamily,
        fontSize: fontSize,
        fontWeight: FontWeight.w400,
        height: lineHeight,
        color: AppColors.black
        // package: AppConstants.packageName,
        );
  }

  // Function to calculate line height based on font size and a factor
  static double calculateLineHeight(double lineHeight, double fontSize) {
    return lineHeight / fontSize;
  }

  // Text styles for different sizes using the getTextStyle function
  static TextStyle textXs = _getTextStyle(AppDimens.font12,
      calculateLineHeight(14.52, AppDimens.font12)); // text-xs
  static TextStyle textSm = _getTextStyle(AppDimens.font14,
      calculateLineHeight(16.94, AppDimens.font14)); // text-sm
  static TextStyle textBase = _getTextStyle(AppDimens.font16,
      calculateLineHeight(19.36, AppDimens.font16)); // text-base
  static TextStyle textLg = _getTextStyle(AppDimens.font18,
      calculateLineHeight(21.78, AppDimens.font18)); // text-lg
  static TextStyle textXl = _getTextStyle(
      AppDimens.font20, calculateLineHeight(24.2, AppDimens.font20)); // text-xl
  static TextStyle text2xl = _getTextStyle(AppDimens.font24,
      calculateLineHeight(29.05, AppDimens.font24)); // text-2xl
  static TextStyle text3xl = _getTextStyle(AppDimens.font30,
      calculateLineHeight(36.31, AppDimens.font30)); // text-3xl
  static TextStyle text4xl = _getTextStyle(AppDimens.font36,
      calculateLineHeight(43.57, AppDimens.font36)); // text-4xl
  static TextStyle text5xl = _getTextStyle(AppDimens.font48,
      calculateLineHeight(58.09, AppDimens.font48)); // text-5xl
  static TextStyle text6xl = _getTextStyle(AppDimens.font60,
      calculateLineHeight(72.61, AppDimens.font60)); // text-6xl

  static TextStyle get medium => const TextStyle(fontWeight: FontWeight.w500);

  static TextStyle get semiBold => const TextStyle(fontWeight: FontWeight.w600);

  static TextStyle get bold => const TextStyle(fontWeight: FontWeight.w700);

  static TextStyle get extraBold =>
      const TextStyle(fontWeight: FontWeight.w800);
}

extension AppStyleExtension on TextStyle {
  TextStyle addAll(List<TextStyle> list) {
    TextStyle updatedStyle = this;
    for (TextStyle style in list) {
      updatedStyle = updatedStyle.merge(style);
    }
    return updatedStyle;
  }

  TextStyle leading(double factor) => TextStyle(
      height: AppTextStyle.calculateLineHeight(factor, fontSize ?? 14.0));

  TextStyle get leading4 => leading(16.0);

  TextStyle get leading5 => leading(20.0);

  TextStyle get leading6 => leading(24.0);

  TextStyle get leading7 => leading(28.0);

  TextStyle get leading8 => leading(32.0);

  TextStyle get leading9 => leading(36.0);
}
