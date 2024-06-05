import 'dart:io';

import 'package:flutter/material.dart';

class AppColors {
  static const Color transparent = Colors.transparent;

  // Greys
  static const Color gray900 = Color(0xFF111827);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray500 = Color(0xFF6B7280);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray200 = Color(0xFFE5E7EB);
  static const Color gray100 = Color(0xFFF3F4F6);

  // Primitives
  static const Color white = Colors.white;
  static const Color black = Colors.black;

  // Primary
  static const Color indigo600Main = Color(0xFF4F46E5);
  static const Color indigo600Light = Color(0xFF6366F1);
  static const Color indigo600Dark = Color(0xFF3730A3);
  static const Color indigo700 = Color(0xFF4338CA);

  // Secondary
  static const Color indigo50 = Color(0xFFEEF2FF);
  static const Color indigo100 = Color(0xFFE0E7FF);

  // Background
  static const Color gray50 = Color(0xFFF9FAFB);

  // Text
  static const Color grey900Normal = Color(0xFF111827);
  static const Color grey500Placeholder = Color(0xFF6B7280);
  static const Color grey400Disabled = Color(0xFF9CA3AF);

  // Data
  static const Color yellow400Normal = Color(0xFFFBBF24);
  static const Color yellow500 = Color(0xFFF59E0B);
  static const Color yellow900Dark = Color(0xFF78350F);
  static const Color yellow100 =
      Color(0xFFFFE082); // Generated based on yellow400Normal and yellow500

  static const Color blue50 = Color(0xFFEFF6FF);
  static const Color lBlue500Normal = Color(0xFF0EA5E9);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color blue600 = Color(0xFF2563EB);
  static const Color lBlue900Dark = Color(0xFF0C4A6E);

  static const Color green500Normal = Color(0xFF10B981);
  static const Color green900Dark = Color(0xFF064E3B);

  static const Color indigo500Normal = Color(0xFF6366F1);
  static const Color indigo900Dark = Color(0xFF312E81);

  // Opacity
  static const Color white20Opacity = Color.fromRGBO(255, 255, 255, 0.2);
  static const Color black75Opacity = Color.fromRGBO(0, 0, 0, 0.75);

  // Feedback
  static const Color green100 = Color(0xFFD1FAE5);
  static const Color green800 = Color(0xFF065F46);
  static const Color green500Success = Color(0xFF10B981);
  static const Color red500 = Color(0xFFEF4444);
  static const Color red600Error = Color(0xFFDC2626);
  static const Color red100 = Color(0xFFFEE2E2);
  static const Color red800 = Color(0xFF991B1B);

  static const Color purple500 = Color(0xFF8B5CF6);
  static const Color purple600 = Color(0xFF7C3AED);
  static const Color purple900 = Color(0xFF4C1D95);

  static const Color backgroundBlueGray = Color(0xFFF2F5FB);
  static const Color slateGray75 = Color(0xBF6B7280);
  static const Color iOSAlertDialog = Color(0xFFF0F0F0);
  static const Color snackBarBackground = Color.fromRGBO(107, 114, 128, 0.75);

  static Color? adaptiveDialogColor = Platform.isAndroid ? blue50 : null;
  static const Color androidDialogColor = blue50;

  // BMI Graph Colors
  static const bmiGraphColor1 = Color(0xFF27B1FF);
  static const bmiGraphColor2 = Color(0xFFA2E40C);
  static const bmiGraphColor3 = Color(0xFFACD90B);
  static const bmiGraphColor4 = Color(0xFFF18300);
  static const bmiGraphColor5 = Color(0xFFE7221A);
}
