import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../nutrition_ai_module.dart';
import '../../../common/constant/app_constants.dart';
import '../../../common/models/food_record/meal_label.dart';
import '../../../common/util/context_extension.dart';
import '../../../common/util/double_extensions.dart';
import '../../../common/util/snackbar_extension.dart';
import '../../dashboard/dashboard_page.dart';
import '../../food_search/food_search_page.dart';
import '../../my_foods/custom_foods/food_creator/food_creator_page.dart';
import '../../my_foods/recipes/recipe_creator/ui/model/navigation_data_provider.dart';
import '../../my_foods/recipes/recipe_creator/ui/recipe_creator_page.dart';
import '../bloc/edit_food_bloc.dart';
import '../nutrition_information/nutrition_information_page.dart';
import 'dialogs/create_user_food_dialog.dart';
import 'dialogs/open_food_facts_dialog.dart';
import 'dialogs/user_food_not_found_dialog.dart';
import 'dialogs/user_recipe_not_found_dialog.dart';
import 'sections/action_button_section.dart';
import 'sections/ingredients_section.dart';
import 'sections/meal_time_section.dart';
import 'sections/title_section.dart';
import 'widgets/typedefs.dart';
import 'widgets/widgets.dart';

part 'models/edit_food_page_params.dart';
part 'models/navigation_data_provider.dart';
part 'screen/edit_food_screen.dart';

class EditFoodPage extends StatefulWidget {
  const EditFoodPage._({required this.params});

  final EditFoodPageParams params;

  static Future navigate({
    required BuildContext context,
    required EditFoodPageParams params,
  }) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return EditFoodPage._(params: params);
        },
      ),
    );
  }

  @override
  State<EditFoodPage> createState() => _EditFoodPageState();
}

class _EditFoodPageState extends State<EditFoodPage> {
  @override
  Widget build(BuildContext context) {
    return NavigationDataProvider(
      params: widget.params,
      child: BlocProvider(
        create: (context) => EditFoodBloc(),
        child: EditFoodScreen(),
      ),
    );
  }
}
