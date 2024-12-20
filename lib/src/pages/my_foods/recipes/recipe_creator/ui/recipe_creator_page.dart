import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../common/constant/app_colors.dart';
import '../../../../../common/domain/use_cases/food_logs/convert_food_data_info_to_food_record_use_case.dart';
import '../../../../../common/util/context_extension.dart';
import '../../../../../common/util/snackbar_extension.dart';
import '../../../../../common/widgets/custom_app_bar_widget.dart';
import '../../../../dashboard/dashboard_page.dart';
import '../../../my_foods_page.dart';
import '../bloc/recipe_creator_bloc.dart';
import 'model/navigation_data_provider.dart';
import 'sections/action_buttons_section.dart';
import 'sections/ingredients_section.dart';
import 'sections/recipe_details_section.dart';
import 'sections/serving_size_section.dart';
import 'widgets/add_ingredient_speed_dial_widget.dart';

part 'screen/recipe_creator_screen.dart';

class RecipeCreatorPage extends StatelessWidget {
  const RecipeCreatorPage({
    required this.params,
    super.key,
  });

  final NavigationData params;

  static Future navigate({
    required BuildContext context,
    NavigationData params = const NavigationData(),
  }) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RecipeCreatorPage(
          params: params,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationDataProvider(
      params: params,
      child: BlocProvider(
        create: (context) => RecipeCreatorBloc(convertFoodDataInfoToFoodRecordUseCase: ConvertFoodDataInfoToFoodRecordUseCase()),
        child: const _RecipeCreatorScreen(),
      ),
    );
  }
}
