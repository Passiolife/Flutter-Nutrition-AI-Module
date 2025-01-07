import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/router/routes.dart';
import '../../common/util/show_widget_util.dart';
import 'bloc/nutrition_facts_bloc.dart';
import 'sections/camera_section.dart';
import 'sections/header_section.dart';
import 'widgets/capture_nutrition_facts_label_widget.dart';

part 'screen/nutrition_facts_screen.dart';

class NutritionFactsPage extends StatefulWidget {
  const NutritionFactsPage({super.key});

  static MaterialPageRoute route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: Routes.nutritionFacts),
      builder: (_) => NutritionFactsPage(),
    );
  }

  @override
  State<NutritionFactsPage> createState() => _NutritionFactsPageState();
}

class _NutritionFactsPageState extends State<NutritionFactsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NutritionFactsBloc(),
      child: _NutritionFactsScreen(),
    );
  }
}
