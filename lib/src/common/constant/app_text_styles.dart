import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

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
  static TextStyle textXs =
      _getTextStyle(12.sp, calculateLineHeight(14.52, 12.sp)); // text-xs
  static TextStyle textSm =
      _getTextStyle(14.sp, calculateLineHeight(16.94, 14.sp)); // text-sm
  static TextStyle textBase =
      _getTextStyle(16.sp, calculateLineHeight(19.36, 16.sp)); // text-base
  static TextStyle textLg =
      _getTextStyle(18.sp, calculateLineHeight(21.78, 18.sp)); // text-lg
  static TextStyle textXl =
      _getTextStyle(20.sp, calculateLineHeight(24.2, 20.sp)); // text-xl
  static TextStyle text2xl =
      _getTextStyle(24.sp, calculateLineHeight(29.05, 24.sp)); // text-2xl
  static TextStyle text3xl =
      _getTextStyle(30.sp, calculateLineHeight(36.31, 30.sp)); // text-3xl

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
