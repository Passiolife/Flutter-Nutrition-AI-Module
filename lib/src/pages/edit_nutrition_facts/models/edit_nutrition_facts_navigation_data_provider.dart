import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../common/models/food_record/food_record.dart';

class EditNutritionFactsNavigationDataProvider extends InheritedWidget {
  const EditNutritionFactsNavigationDataProvider({
    super.key,
    required this.foodRecord,
    this.imageBytes,
    this.barcode,
    this.index,
    this.positiveButtonText,
    this.onPositiveButtonTap,
    this.onNegativeButtonTap,
    this.shouldLog = false,
    this.shouldReturnOnSave = false,
    required super.child,
  });

  final FoodRecord? foodRecord;
  final Uint8List? imageBytes;

  // Added barcode if user comes from "Barcode Missing Data" dialog in Scan A Barcode screen.
  final String? barcode;
  final int? index;

  final String? positiveButtonText;
  final VoidCallback? onPositiveButtonTap;

  final VoidCallback? onNegativeButtonTap;

  final bool shouldLog;
  final bool shouldReturnOnSave;

  @override
  bool updateShouldNotify(EditNutritionFactsNavigationDataProvider oldWidget) {
    return foodRecord != oldWidget.foodRecord &&
        imageBytes != oldWidget.imageBytes &&
        barcode != oldWidget.barcode &&
        index != oldWidget.index &&
        shouldLog != oldWidget.shouldLog &&
        shouldReturnOnSave != oldWidget.shouldReturnOnSave &&
        onNegativeButtonTap != oldWidget.onNegativeButtonTap &&
        positiveButtonText != oldWidget.positiveButtonText &&
        onPositiveButtonTap != oldWidget.onPositiveButtonTap;
  }

  static EditNutritionFactsNavigationDataProvider? maybeOf(
      BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<
        EditNutritionFactsNavigationDataProvider>();
  }

  static EditNutritionFactsNavigationDataProvider of(BuildContext context) {
    final provider = maybeOf(context);
    assert(provider != null, 'No NavigationDataProvider found in context');
    return provider!;
  }
}
