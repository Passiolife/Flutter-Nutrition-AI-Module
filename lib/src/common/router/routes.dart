import 'package:flutter/material.dart';
import '../../pages/dashboard/dashboard_page.dart';
import '../../pages/food_scan/food_scan_page.dart';
import '../../pages/food_search/food_search_page.dart';
import '../constant/app_common_constants.dart';

class Routes {
  // Define the initial page route name
  static const initialPage = dashboardPage;

  // Define route names as constants for better code readability
  static const dashboardPage = 'dashboard';
  static const foodSearchPage = 'foodSearchPage';
  static const foodScanPage = 'foodScanPage';
  static const editFoodPage = 'editFoodPage';

  // Route generator function to handle navigation to different routes
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Case for navigating to the dashboard page
      case dashboardPage:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            final arguments = settings.arguments;
            String? page;
            if (arguments != null && arguments is Map) {
              if (arguments.containsKey(AppCommonConstants.page)) {
                page = arguments[AppCommonConstants.page];
              }
            }
            return DashboardPage(page: page);
          },
        );
      // Case for navigating to the food search page
      case foodSearchPage:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            final arguments = settings.arguments;
            bool needsReturn = true;
            if (arguments != null && arguments is bool) {
              needsReturn = arguments;
            }
            return FoodSearchPage(needsReturn: needsReturn);
          },
        );
      case foodScanPage:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            final arguments = settings.arguments;
            late DateTime dateTime;
            if (arguments != null && arguments is Map) {
              if (arguments.containsKey(AppCommonConstants.dateTime)) {
                dateTime = arguments[AppCommonConstants.dateTime];
              }
            }
            return FoodScanPage(selectedDateTime: dateTime);
          },
        );
      /*case editFoodPage:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) {
            final arguments = settings.arguments;
            PassioFoodItem? foodItem;
            FoodRecord? foodRecord;
            FoodRecordIngredient? foodRecordIngredient;
            String? iconHeroTag;
            bool needsReturn = false;
            bool visibleSwitch = false;
            if (arguments is Map) {
              final data = arguments.containsKey(AppCommonConstants.data)
                  ? arguments[AppCommonConstants.data]
                  : null;
              if (data is PassioFoodItem?) {
                foodItem = data;
              } else if (data is FoodRecordIngredient?) {
                foodRecordIngredient = data;
              } else {
                foodRecord = data;
              }
              iconHeroTag =
                  arguments.containsKey(AppCommonConstants.iconHeroTag)
                      ? arguments[AppCommonConstants.iconHeroTag]
                      : null;
              needsReturn =
                  arguments.containsKey(AppCommonConstants.needsReturn)
                      ? arguments[AppCommonConstants.needsReturn]
                      : false;
              visibleSwitch =
                  arguments.containsKey(AppCommonConstants.visibleSwitch)
                      ? arguments[AppCommonConstants.visibleSwitch]
                      : false;
            }
            if (foodItem != null) {
              return EditFoodPage.fromPassioFoodItem(
                foodItem: foodItem,
                needsReturn: needsReturn,
                iconHeroTag: iconHeroTag,
                visibleSwitch: visibleSwitch,
              );
            } else if (foodRecordIngredient != null) {
              return EditFoodPage.fromFoodRecordIngredient(
                foodRecordIngredient: foodRecordIngredient,
                needsReturn: needsReturn,
                visibleMealTimeView: false,
                visibleDateView: false,
                visibleAddIngredient: false,
                visibleMoreDetails: false,
                iconHeroTag: iconHeroTag,
                visibleSwitch: visibleSwitch,
              );
            }
            return EditFoodPage.fromFoodRecord(
              foodRecord: foodRecord,
              needsReturn: needsReturn,
              iconHeroTag: iconHeroTag,
              visibleSwitch: visibleSwitch,
            );
          },
        );*/
      // Default case when route name is not found
      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
