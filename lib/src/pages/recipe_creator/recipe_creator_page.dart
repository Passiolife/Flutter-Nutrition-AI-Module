import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/extension/core_extension.dart';
import '../../common/models/food_record/food_record.dart';
import '../../common/router/routes.dart';
import '../../common/widgets/app_bar/primary_app_bar.dart';
import 'bloc/recipe_creator_bloc.dart';
import 'model/recipe_creator_navigation_data_model.dart';

part 'screen/recipe_creator_screen.dart';

class RecipeCreatorPage extends StatelessWidget {
  const RecipeCreatorPage({
    required this.logUponCreate,
    this.recipeFoodRecord,
    this.loggedFoodRecord,
    super.key,
  });

  final bool logUponCreate;
  final FoodRecord? loggedFoodRecord;
  final FoodRecord? recipeFoodRecord;

  static MaterialPageRoute route({
    FoodRecord? loggedFoodRecord,
    FoodRecord? recipeFoodRecord,
    bool logUponCreate = false,
  }) {
    return MaterialPageRoute(
      settings: RouteSettings(name: Routes.recipeCreator),
      builder: (_) => RecipeCreatorPage(
        logUponCreate: logUponCreate,
        loggedFoodRecord: loggedFoodRecord,
        recipeFoodRecord: recipeFoodRecord,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RecipeCreatorNavigationDataModel(
      logUponCreate: logUponCreate,
      loggedFoodRecord: loggedFoodRecord,
      recipeFoodRecord: recipeFoodRecord,
      child: BlocProvider(
        create: (context) => RecipeCreatorBloc(),
        child: const _RecipeCreatorScreen(),
      ),
    );
  }
}
