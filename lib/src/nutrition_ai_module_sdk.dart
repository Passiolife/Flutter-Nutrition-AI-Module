import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'common/connectors/local_db_connector.dart';
import 'common/connectors/passio_connector.dart';
import 'common/constant/app_constants.dart';
import 'common/locale/app_localizations.dart';
import 'common/models/user_profile/user_profile_model.dart';
import 'common/util/database_helper.dart';
import 'common/util/preference_store.dart';
import 'common/util/user_session.dart';
import 'nutrition_ai_module_configuration.dart';
import 'pages/dashboard/dashboard_page.dart';

/// The `NutritionAIModule` class is a singleton that handles the initialization
/// and configuration of the Nutrition AI module. It manages the connection
/// to different storage connectors and sets up the user interface and user profile.
class NutritionAIModule {
  /// Singleton instance of `NutritionAIModule`.
  static final NutritionAIModule _instance =
      NutritionAIModule._privateConstructor();

  /// Private constructor for the singleton pattern.
  NutritionAIModule._privateConstructor();

  /// Getter to retrieve the singleton instance.
  static NutritionAIModule get instance => _instance;

  /// [configuration] holds the key and connector data.
  var configuration = NutritionConfiguration(connector: LocalDBConnector());

  /// Sets the Passio connector for the configuration.
  ///
  /// This method is used to establish communication with storage by taking a
  /// Passio connector as its parameter.
  ///
  /// Returns the singleton instance of `NutritionAIModule`.
  NutritionAIModule setPassioConnector(PassioConnector passioConnector) {
    configuration = configuration.copyWith(connector: passioConnector);
    return this;
  }

  /// Launches the Nutrition AI module.
  ///
  /// This method requires a [BuildContext] parameter to initiate the Nutrition AI module.
  /// It checks the type of connector, initializes the local database if needed,
  /// sets the preferred device orientation to portrait mode, loads the language file for localization,
  /// initializes the preference store, retrieves and sets the user profile,
  /// initializes the screen for responsive UI, and navigates to the dashboard page.
  ///
  /// Returns a [Future] that completes when the launch process is finished.
  Future<void> launch(BuildContext context) async {
    // Check the type of connector and initialize the local database if needed.
    if (configuration.connector is LocalDBConnector) {
      await DatabaseHelper.instance.init();
    }

    // Set preferred device orientation to portrait mode
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Set system UI overlay style.
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    // Load language file for localization
    await AppLocalizations.instance.loadLanguageFile(
        'packages/${AppCommonConstants.packageName}/assets/translation/app_en.json');

    // Initialize preference store.
    await PreferenceStore.instance.init();

    // Getting user profile from connector.
    final userProfile = await configuration.connector.fetchUserProfile();
    if (userProfile != null) {
      // Set the user profile in the user session.
      UserSession.instance.userProfile = userProfile;
    } else {
      // Create a new user profile and store it in the database.
      UserSession.instance.userProfile = UserProfileModel();
      if (UserSession.instance.userProfile != null) {
        // Storing user profile data in database.
        await configuration.connector.updateUserProfile(
          userProfile: UserSession.instance.userProfile!,
          isNew: true,
        );
      }
    }

    // Check if the current widget is mounted before proceeding
    if (context.mounted) {
      // Initialize ScreenUtil for responsive UI
      ScreenUtil.init(
        context,
        designSize: Size(AppDimens.designWidth, AppDimens.designHeight),
      );

      // Navigate to the DashboardPage screen
      await DashboardPage.navigate(context);
    }
  }
}
