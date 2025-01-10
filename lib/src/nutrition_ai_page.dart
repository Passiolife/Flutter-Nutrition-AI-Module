import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../nutrition_ai_module.dart';
import 'common/constant/app_theme.dart';
import 'common/router/clear_focus_on_push_observer.dart';
import 'common/router/navigation_route_observer.dart';
import 'common/router/routes.dart';
import 'pages/advisor/advisor_page.dart';
import 'pages/dashboard/dashboard_page.dart';
import 'pages/edit_food/ui/edit_food_page.dart';
import 'pages/food_search/food_search_page.dart';
import 'pages/my_foods/custom_foods/food_creator/barcode_scanner/barcode_scanner_page.dart';
import 'pages/my_foods/custom_foods/food_creator/food_creator_page.dart';
import 'pages/my_foods/my_foods_page.dart';
import 'pages/my_foods/recipes/recipe_creator/ui/model/navigation_data_provider.dart';
import 'pages/my_foods/recipes/recipe_creator/ui/recipe_creator_page.dart';
import 'pages/my_profile/my_profile_page.dart';
import 'pages/nutrition_facts/nutrition_facts_page.dart';
import 'pages/photo_preview/photo_preview_page.dart';
import 'pages/scan_a_barcode/food_scan_page.dart';
import 'pages/settings/settings_page.dart';
import 'pages/use_image/select_photo/select_photo_page.dart';
import 'pages/use_image/take_photo/take_photo_page.dart';
import 'pages/use_image/take_photo/take_photo_result/take_photo_result_page.dart';
import 'pages/voice_logging/voice_logging_page.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

class NavigationAIPage extends StatelessWidget {
  const NavigationAIPage({super.key});

  // Static method to navigate to the current page.
  static Future<void> navigate(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NavigationAIPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme().lightTheme,
      child: Navigator(
        key: _navigatorKey,
        initialRoute: Routes.initialPage,
        observers: [NavigationRouteObserver.instance, ClearFocusOnPushObserver()],
        onGenerateRoute: _generateRoute,
      ),
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    if (settings.name == Routes.dashboard) {
      if (arguments is int) {
        return DashboardPage.route(page: arguments);
      } else {
        return DashboardPage.route();
      }
    } else if (settings.name == Routes.advisor) {
      return AdvisorPage.route();
    } else if (settings.name == Routes.editFood) {
      if (arguments is EditFoodPageParams) {
        return EditFoodPage.route(params: arguments);
      } else {
        return throw Exception('Invalid arguments');
      }
    } else if (settings.name == Routes.foodScan) {
      DateTime dateTime = DateTime.now();
      if (arguments is DateTime) {
        dateTime = arguments;
      }
      return FoodScanPage.route(selectedDateTime: dateTime);
    } else if (settings.name == Routes.foodSearch) {
      bool needsReturn = true;
      if (arguments is bool) {
        needsReturn = arguments;
      }
      return FoodSearchPage.route(needsReturn: needsReturn);
    } else if (settings.name == Routes.myFoods) {
      int page = 0;
      if (arguments is int) {
        page = arguments;
      }
      return MyFoodsPage.route(page: page);
    } else if (settings.name == Routes.foodCreator) {
      FoodRecord? loggedFoodRecord;
      FoodRecord? userFoodRecord;
      PassioNutritionFacts? nutritionFacts;
      bool logUponCreate = false;
      if (arguments != null && arguments is List) {
        if (arguments[0] is FoodRecord?) {
          loggedFoodRecord = arguments[0];
        }
        if (arguments[1] is FoodRecord?) {
          userFoodRecord = arguments[1];
        }
        if (arguments[2] is PassioNutritionFacts?) {
          nutritionFacts = arguments[2];
        }
        if (arguments[3] is bool) {
          logUponCreate = arguments[3];
        }
      }
      return FoodCreatorPage.route(
        loggedFoodRecord: loggedFoodRecord,
        userFoodRecord: userFoodRecord,
        nutritionFacts: nutritionFacts,
        logUponCreate: logUponCreate,
      );
    } else if (settings.name == Routes.barcodeScanner) {
      return BarcodeScannerPage.route();
    } else if (settings.name == Routes.recipeCreator) {
      RecipeCreatorNavigationData params = const RecipeCreatorNavigationData();
      if (arguments is RecipeCreatorNavigationData) {
        params = arguments;
      }
      return RecipeCreatorPage.route(params: params);
    } else if (settings.name == Routes.profile) {
      return MyProfilePage.route();
    } else if (settings.name == Routes.takePhoto) {
      bool returnResult = false;
      int maxLimit = 7;
      if (arguments != null && arguments is List) {
        if (arguments[0] is bool) {
          returnResult = arguments[0];
        }
        if (arguments[1] is int) {
          maxLimit = arguments[1];
        }
      }
      return TakePhotoPage.route(
          returnResult: returnResult, maxLimit: maxLimit);
    } else if (settings.name == Routes.takePhotoResult) {
      List<Uint8List>? capturedImages = [];
      if (arguments is List<Uint8List>) {
        capturedImages = arguments;
      }
      return TakePhotoResultPage.route(capturedImages: capturedImages);
    } else if (settings.name == Routes.selectPhoto) {
      bool returnResult = false;
      int maxLimit = 7;
      if (arguments != null && arguments is List) {
        if (arguments[0] is bool) {
          returnResult = arguments[0];
        }
        if (arguments[1] is int) {
          maxLimit = arguments[1];
        }
      }
      return SelectPhotoPage.route(
          returnResult: returnResult, maxLimit: maxLimit);
    } else if (settings.name == Routes.voiceLogging) {
      return VoiceLoggingPage.route();
    } else if (settings.name == Routes.settings) {
      return SettingsPage.route();
    } else if (settings.name == Routes.photoPreview) {
      XFile? file = arguments as XFile?;
      return PhotoPreviewPage.route(file: file);
    } else if (settings.name == Routes.nutritionFacts) {
      return NutritionFactsPage.route();
    } else {
      return MaterialPageRoute(builder: (context) {
        return SizedBox.shrink();
      });
    }
  }
}
