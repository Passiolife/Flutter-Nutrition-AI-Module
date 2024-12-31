import 'package:flutter/material.dart';

class DailyNutritionModel {
  final String title;
  final String subtitle;
  final String footer;

  final double value;

  final Color progressColor;
  final Color? backgroundColor;

  DailyNutritionModel({
    required this.title,
    required this.subtitle,
    required this.footer,
    required this.value,
    required this.progressColor,
    this.backgroundColor,
  });
}
