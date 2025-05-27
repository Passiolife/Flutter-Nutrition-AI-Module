import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../nutrition_ai_module.dart';
import '../../common/data/repository/custom_food_repository_impl.dart';
import '../../common/data/repository/food_log_repositoy_impl.dart';
import '../../common/data/repository/nutrition_ai_repository_impl.dart';
import '../../common/router/routes.dart';
import 'bloc/food_scan_bloc.dart';
import 'screen/food_scan_screen.dart';

class FoodScanPage extends StatelessWidget {
  const FoodScanPage({required this.selectedDateTime, super.key});

  final DateTime selectedDateTime;

  static MaterialPageRoute route({required DateTime selectedDateTime}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: Routes.foodScan),
      builder: (_) => FoodScanPage(selectedDateTime: selectedDateTime),
    );
  }

  @override
  Widget build(BuildContext context) {
    final connector = NutritionAIModule.instance.configuration.connector;
    final nutritionAIRepository = NutritionAIRepositoryImpl();
    final foodLogRepository = FoodLogRepositoryImpl(connector: connector);
    final customFoodRepository = CustomFoodRepositoryImpl(connector: connector);

    return BlocProvider(
      create: (context) => FoodScanBloc(
        nutritionRepository: nutritionAIRepository,
        foodLogRepository: foodLogRepository,
        customFoodRepository: customFoodRepository,
      ),
      child: FoodScanScreen(),
    );
  }
}
