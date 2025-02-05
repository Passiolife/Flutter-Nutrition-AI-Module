import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../nutrition_ai_module.dart';
import '../../common/constant/app_constants.dart';
import '../../common/domain/use_cases/custom_food/create_custom_food_ingredient_use_case.dart';
import '../../common/extension/core_extension.dart';
import '../../common/util/navigation_utils/hero_dialog_route.dart';
import 'bloc/edit_nutrition_facts_bloc.dart';
import 'models/edit_nutrition_facts_navigation_data_provider.dart';
import 'sections/action_buttons_section.dart';
import 'sections/details_section.dart';
import 'sections/header_section.dart';
import 'sections/nutrition_facts_section.dart';
import 'sections/portion_section.dart';

part 'screen/edit_nutrition_facts_screen.dart';

class EditNutritionFactsPage extends StatelessWidget {
  const EditNutritionFactsPage({
    required this.foodRecord,
    required this.imageBytes,
    required this.visibleSubtitle,
    this.barcode,
    this.index,
    this.positiveButtonText,
    this.onPositiveButtonTap,
    this.onNegativeButtonTap,
    this.shouldLog = false,
    this.shouldReturnOnSave = false,
    this.initialValidate = false,
    this.routeName,
    super.key,
  });

  final FoodRecord? foodRecord;
  final String? barcode;
  final Uint8List? imageBytes;
  final int? index;

  final String? positiveButtonText;
  final String? routeName;

  final VoidCallback? onPositiveButtonTap;

  final VoidCallback? onNegativeButtonTap;

  final bool shouldLog;
  final bool shouldReturnOnSave;

  final bool initialValidate;

  final bool visibleSubtitle;

  static Future<FoodRecord?> navigate({
    required BuildContext context,
    required FoodRecord? foodRecord,
    required Uint8List? imageBytes,
    String? barcode,
    int? index,
    String? positiveButtonText,
    VoidCallback? onPositiveButtonTap,
    VoidCallback? onNegativeButtonTap,
    bool shouldLog = false,
    bool shouldReturnOnSave = false,
    bool initialValidate = false,
    bool visibleSubtitle = false,
    String? routeName,
  }) {
    return Navigator.push(
      context,
      HeroDialogRoute(
        child: EditNutritionFactsPage(
          foodRecord: foodRecord,
          imageBytes: imageBytes,
          barcode: barcode,
          index: index,
          positiveButtonText: positiveButtonText,
          onPositiveButtonTap: onPositiveButtonTap,
          onNegativeButtonTap: onNegativeButtonTap,
          shouldLog: shouldLog,
          shouldReturnOnSave: shouldReturnOnSave,
          initialValidate: initialValidate,
          visibleSubtitle: visibleSubtitle,
          routeName: routeName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final createCustomFoodIngredientUseCase =
        CreateCustomFoodIngredientUseCase();

    return EditNutritionFactsNavigationDataProvider(
      visibleSubtitle: visibleSubtitle,
      foodRecord: foodRecord,
      imageBytes: imageBytes,
      barcode: barcode,
      index: index,
      positiveButtonText: positiveButtonText,
      onPositiveButtonTap: onPositiveButtonTap,
      initialValidate: initialValidate,
      routeName: routeName,
      child: BlocProvider(
        create: (_) => EditNutritionFactsBloc(
          createCustomFoodIngredientUseCase: createCustomFoodIngredientUseCase,
        ),
        child: const _EditNutritionFactsScreen(),
      ),
    );
  }
}
