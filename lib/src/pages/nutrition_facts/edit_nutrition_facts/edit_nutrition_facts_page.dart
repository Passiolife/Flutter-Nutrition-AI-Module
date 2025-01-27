import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../nutrition_ai_module.dart';
import '../../../common/constant/app_constants.dart';
import '../../../common/data/repository/custom_food_repository_impl.dart';
import '../../../common/data/repository/food_log_repositoy_impl.dart';
import '../../../common/domain/use_cases/custom_food/create_custom_food_ingredient_use_case.dart';
import '../../../common/extension/context_extension.dart';
import '../../../common/extension/string_extensions.dart';
import '../../../common/router/routes.dart';
import '../../../common/util/navigation_utils/hero_dialog_route.dart';
import '../../../common/util/show_widget_util.dart';
import '../../../common/widgets/item_added_to_diary_widget.dart';
import '../../../nutrition_ai_module_configuration.dart';
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
    this.barcode,
    this.index,
    super.key,
  });

  final FoodRecord? foodRecord;
  final String? barcode;
  final Uint8List? imageBytes;
  final int? index;

  static Future<FoodRecord?> navigate({
    required BuildContext context,
    required FoodRecord? foodRecord,
    required Uint8List? imageBytes,
    String? barcode,
    int? index,
    bool showMissing = false,
  }) {
    return Navigator.push(
      context,
      HeroDialogRoute(
        child: EditNutritionFactsPage(
          foodRecord: foodRecord,
          imageBytes: imageBytes,
          barcode: barcode,
          index: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final NutritionConfiguration configuration =
        NutritionAIModule.instance.configuration;
    final foodLogRepository =
        FoodLogRepositoryImpl(connector: configuration.connector);
    final customFoodRepository =
        CustomFoodRepositoryImpl(connector: configuration.connector);

    final createCustomFoodIngredientUseCase =
        CreateCustomFoodIngredientUseCase();

    return EditNutritionFactsNavigationDataProvider(
      foodRecord: foodRecord,
      imageBytes: imageBytes,
      barcode: barcode,
      index: index,
      child: BlocProvider(
        create: (_) => EditNutritionFactsBloc(
          foodLogRepository: foodLogRepository,
          customFoodRepository: customFoodRepository,
          createCustomFoodIngredientUseCase: createCustomFoodIngredientUseCase,
        ),
        child: const _EditNutritionFactsScreen(),
      ),
    );
  }
}
