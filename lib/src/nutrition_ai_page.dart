import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../nutrition_ai_module.dart';
import 'common/constant/app_constants.dart';
import 'common/constant/app_theme.dart';
import 'common/router/clear_focus_on_push_observer.dart';
import 'common/router/navigation_route_observer.dart';
import 'common/router/routes.dart';
import 'common/util/navigation_utils/core_route.dart';
import 'pages/adjust_serving_size/adjust_serving_size_page.dart';
import 'pages/advisor/advisor_page.dart';
import 'pages/barcode_scanner/barcode_scanner_page.dart';
import 'pages/dashboard/dashboard_page.dart';
import 'pages/edit_food/ui/edit_food_page.dart';
// import 'pages/food_creator/food_creator_page.dart';
import 'pages/my_foods_old/custom_foods/food_creator/food_creator_page.dart';
import 'pages/my_foods_old/recipes/recipe_creator/ui/recipe_creator_page.dart';
import 'pages/my_foods_old/recipes/recipe_creator/ui/model/navigation_data_provider.dart';
import 'pages/food_search/food_search_page.dart';
import 'pages/home/weight/weight_page_old.dart';
import 'pages/my_foods_old/my_foods_page.dart';
import 'pages/my_profile/my_profile_page.dart';
import 'pages/nutrition_facts/nutrition_facts_page.dart';
import 'pages/photo_preview/photo_preview_page.dart';
// import 'pages/recipe_creator/recipe_creator_page.dart';
import 'pages/scan_a_barcode/food_scan_page.dart';
import 'pages/settings/settings_page.dart';
import 'pages/use_image/select_photo/select_photo_page.dart';
import 'pages/use_image/take_photo/photo_result/take_photo_result_page.dart';
import 'pages/use_image/take_photo/take_photo_page.dart';
import 'pages/voice_logging/voice_logging_page.dart';
import 'pages/water/add_water/add_water_page.dart';
import 'pages/water/main_water/water_page.dart';

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
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          // if (NavigationRouteObserver.instance.currentRouteName ==
          //     Routes.dashboard) {
          //   _navigatorKey.currentState?.popUntil((_) => false);
          // }
          // if (Navigator.canPop(context)) {
          //   if (NavigationRouteObserver.instance.routeStack.isEmpty) {
          //     WidgetsBinding.instance.addPostFrameCallback((_) {
          //       Navigator.of(context, rootNavigator: true).pop(result);
          //     });
          //     return;
          //   }
          //   WidgetsBinding.instance.addPostFrameCallback((_) {
          //     _navigatorKey.currentState?.pop();
          //   });
          //   return;
          // }
        },
        child: Navigator(
          key: _navigatorKey,
          initialRoute: Routes.initialPage,
          observers: [
            NavigationRouteObserver.instance,
            ClearFocusOnPushObserver()
          ],
          onGenerateRoute: _generateRoute,
        ),
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
      XFile? file;
      String? barcode;
      if (arguments != null && arguments is List) {
        file = arguments[0] as XFile?;
        barcode = arguments[1] as String?;
      }
      return PhotoPreviewPage.route(file: file, barcode: barcode);
    }

    // Nutrition Facts
    else if (settings.name == Routes.nutritionFacts) {
      String? barcode;
      if (arguments != null && arguments is String) {
        barcode = arguments;
      }
      return NutritionFactsPage.route(barcode: barcode);
    }

    else if (settings.name == Routes.adjustServingSize) {
      final Map<String, dynamic> arguments = settings.arguments as Map<String, dynamic>;

      final FoodRecord foodRecord = arguments[AppCommonConstants.data];
      final int? index = arguments[AppCommonConstants.index];
      final Uint8List? image = arguments[AppCommonConstants.image];

      return HeroDialogRoute(
        child: AdjustServingSizePage(
          foodRecord: foodRecord,
          image: image,
          index: index,
        ),
      );
    }

    // Empty Screen
    else {
      return MaterialPageRoute(builder: (context) {
        return SizedBox.shrink();
      });
    }
  }

  // Route<dynamic>? _generateRouteNew(RouteSettings settings) {
  //   final arguments = settings.arguments;
  //   if (settings.name == Routes.dashboard) {
  //     if (arguments is int) {
  //       return DashboardPage.route(page: arguments);
  //     } else {
  //       return DashboardPage.route();
  //     }
  //   }
  //   // Water Page
  //   else if (settings.name == Routes.waterPage) {
  //     return WaterPage.route();
  //   } else if (settings.name == Routes.addWaterPage) {
  //     final WaterRecord? record = arguments as WaterRecord?;
  //     return AddWaterPage.route(record: record);
  //   }
  //
  //   // Weight Page
  //   else if (settings.name == Routes.weightPage) {
  //     return WeightPage.route();
  //   } else if (settings.name == Routes.advisor) {
  //     return AdvisorPage.route();
  //   } else if (settings.name == Routes.editFood) {
  //     if (arguments is EditFoodPageParams) {
  //       return EditFoodPage.route(params: arguments);
  //     } else {
  //       return throw Exception('Invalid arguments');
  //     }
  //   } else if (settings.name == Routes.foodScan) {
  //     DateTime dateTime = DateTime.now();
  //     if (arguments is DateTime) {
  //       dateTime = arguments;
  //     }
  //     return FoodScanPage.route(selectedDateTime: dateTime);
  //   } else if (settings.name == Routes.foodSearch) {
  //     bool needsReturn = true;
  //     if (arguments is bool) {
  //       needsReturn = arguments;
  //     }
  //     return FoodSearchPage.route(needsReturn: needsReturn);
  //   } else if (settings.name == Routes.myFoods) {
  //     int page = 0;
  //     if (arguments is int) {
  //       page = arguments;
  //     }
  //     return MyFoodsPage.route(page: page);
  //   } else if (settings.name == Routes.foodCreator) {
  //     if(arguments is List) {
  //       final int? index = arguments[0];
  //       final FoodRecord? foodRecord = arguments[1];
  //       return FoodCreatorPage.route(index: index, foodRecord: foodRecord);
  //     }
  //     return FoodCreatorPage.route();
  //     // FoodRecord? loggedFoodRecord;
  //     // FoodRecord? userFoodRecord;
  //     // PassioNutritionFacts? nutritionFacts;
  //     // bool logUponCreate = false;
  //     // if (arguments != null && arguments is List) {
  //     //   if (arguments[0] is FoodRecord?) {
  //     //     loggedFoodRecord = arguments[0];
  //     //   }
  //     //   if (arguments[1] is FoodRecord?) {
  //     //     userFoodRecord = arguments[1];
  //     //   }
  //     //   if (arguments[2] is PassioNutritionFacts?) {
  //     //     nutritionFacts = arguments[2];
  //     //   }
  //     //   if (arguments[3] is bool) {
  //     //     logUponCreate = arguments[3];
  //     //   }
  //     // }
  //     // return FoodCreatorPage.route(
  //     //   loggedFoodRecord: loggedFoodRecord,
  //     //   userFoodRecord: userFoodRecord,
  //     //   nutritionFacts: nutritionFacts,
  //     //   logUponCreate: logUponCreate,
  //     // );
  //   } else if (settings.name == Routes.barcodeScanner) {
  //     return BarcodeScannerPage.route();
  //   } else if (settings.name == Routes.recipeCreator) {
  //     return RecipeCreatorPage.route();
  //     // RecipeCreatorNavigationData params = const RecipeCreatorNavigationData();
  //     // if (arguments is RecipeCreatorNavigationData) {
  //     //   params = arguments;
  //     // }
  //     // return RecipeCreatorPage.route(params: params);
  //   } else if (settings.name == Routes.profile) {
  //     return MyProfilePage.route();
  //   } else if (settings.name == Routes.takePhoto) {
  //     bool returnResult = false;
  //     int maxLimit = 7;
  //     if (arguments != null && arguments is List) {
  //       if (arguments[0] is bool) {
  //         returnResult = arguments[0];
  //       }
  //       if (arguments[1] is int) {
  //         maxLimit = arguments[1];
  //       }
  //     }
  //     return TakePhotoPage.route(
  //         returnResult: returnResult, maxLimit: maxLimit);
  //   } else if (settings.name == Routes.takePhotoResult) {
  //     List<Uint8List>? capturedImages = [];
  //     if (arguments is List<Uint8List>) {
  //       capturedImages = arguments;
  //     }
  //     return TakePhotoResultPage.route(capturedImages: capturedImages);
  //   } else if (settings.name == Routes.selectPhoto) {
  //     bool returnResult = false;
  //     int maxLimit = 7;
  //     if (arguments != null && arguments is List) {
  //       if (arguments[0] is bool) {
  //         returnResult = arguments[0];
  //       }
  //       if (arguments[1] is int) {
  //         maxLimit = arguments[1];
  //       }
  //     }
  //     return SelectPhotoPage.route(
  //         returnResult: returnResult, maxLimit: maxLimit);
  //   } else if (settings.name == Routes.voiceLogging) {
  //     return VoiceLoggingPage.route();
  //   } else if (settings.name == Routes.settings) {
  //     return SettingsPage.route();
  //   } else if (settings.name == Routes.photoPreview) {
  //     XFile? file;
  //     String? barcode;
  //     if (arguments != null && arguments is List) {
  //       file = arguments[0] as XFile?;
  //       barcode = arguments[1] as String?;
  //     }
  //     return PhotoPreviewPage.route(file: file, barcode: barcode);
  //   }
  //
  //   // Nutrition Facts
  //   else if (settings.name == Routes.nutritionFacts) {
  //     String? barcode;
  //     if (arguments != null && arguments is String) {
  //       barcode = arguments;
  //     }
  //     return NutritionFactsPage.route(barcode: barcode);
  //   } else if (settings.name == Routes.adjustServingSize) {
  //     final Map<String, dynamic> arguments =
  //         settings.arguments as Map<String, dynamic>;
  //
  //     final FoodRecord foodRecord = arguments[AppCommonConstants.data];
  //     final int? index = arguments[AppCommonConstants.index];
  //     final Uint8List? image = arguments[AppCommonConstants.image];
  //
  //     return HeroDialogRoute(
  //       child: AdjustServingSizePage(
  //         foodRecord: foodRecord,
  //         image: image,
  //         index: index,
  //       ),
  //     );
  //   }
  //
  //   // Empty Screen
  //   else {
  //     return MaterialPageRoute(builder: (context) {
  //       return SizedBox.shrink();
  //     });
  //   }
  // }
}
