import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/data/repository/nutrition_ai_repository_impl.dart';
import '../../common/router/routes.dart';
import '../../common/util/show_widget_util.dart';
import 'bloc/nutrition_facts_bloc.dart';
import 'models/nutrition_facts_navigation_data.dart';
import 'models/nutrition_facts_navigation_data_provider.dart';
import 'sections/camera_section.dart';
import 'sections/header_section.dart';
import 'sections/preview_section.dart';
import 'widgets/capture_nutrition_facts_label_widget.dart';
import 'widgets/failed_to_analyze_image_widget.dart';
import 'widgets/no_ingredients_label_found_widget.dart';
import 'widgets/no_nutrition_facts_label_found_widget.dart';

part 'screen/nutrition_facts_screen.dart';

class NutritionFactsPage extends StatelessWidget {
  const NutritionFactsPage({
    this.navigationData = const NutritionFactsNavigationData(),
    super.key,
  });

  final NutritionFactsNavigationData? navigationData;

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: Routes.nutritionFacts),
      builder: (_) => NutritionFactsPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NutritionFactsNavigationDataProvider(
      navigationData: navigationData,
      child: BlocProvider(
        create: (context) => NutritionFactsBloc(
            nutritionAIRepository: NutritionAIRepositoryImpl()),
        child: _NutritionFactsScreen(),
      ),
    );
  }
}
