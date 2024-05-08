import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constant/app_dimens.dart';
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
    return ScreenUtilInit(
        designSize: Size(AppDimens.designWidth, AppDimens.designHeight),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_, child) {
          return const Navigator(
            onGenerateRoute: Routes.generateRoute,
            initialRoute: Routes.initialPage,
          );
        });
  }
}
