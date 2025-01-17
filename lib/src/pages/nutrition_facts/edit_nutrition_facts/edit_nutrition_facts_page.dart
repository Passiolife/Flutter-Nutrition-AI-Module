import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/constant/app_constants.dart';
import '../../../common/extension/context_extension.dart';
import '../../../common/models/food_record/food_record.dart';
import '../../../common/util/navigation_utils/hero_dialog_route.dart';
import 'bloc/edit_nutrition_facts_bloc.dart';
import 'models/edit_nutrition_facts_navigation_data_provider.dart';
import 'sections/details_section.dart';

part 'screen/edit_nutrition_facts_screen.dart';

class EditNutritionFactsPage extends StatelessWidget {
  const EditNutritionFactsPage({
    required this.foodRecord,
    required this.index,
    super.key,
  });

  final FoodRecord foodRecord;
  final int? index;

  static Future<FoodRecord?> navigate({
    required BuildContext context,
    required FoodRecord foodRecord,
    int? index,
    bool showMissing = false,
  }) {
    return Navigator.push(
      context,
      HeroDialogRoute(
        child: EditNutritionFactsPage(
          foodRecord: foodRecord,
          index: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return EditNutritionFactsNavigationDataProvider(
      foodRecord: foodRecord,
      index: index,
      child: BlocProvider(
        create: (_) => EditNutritionFactsBloc(),
        child: const _EditNutritionFactsScreen(),
      ),
    );
  }
}
