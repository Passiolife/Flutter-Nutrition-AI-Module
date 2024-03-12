import 'package:flutter/material.dart';

import '../router/routes.dart';

class NutritionAIWidget extends StatelessWidget {
  const NutritionAIWidget({super.key});

  // Static method to navigate to the DashboardPage.
  static void navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NutritionAIWidget()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Navigator(
      onGenerateRoute: Routes.generateRoute,
      initialRoute: Routes.initialPage,
    );
  }
}
