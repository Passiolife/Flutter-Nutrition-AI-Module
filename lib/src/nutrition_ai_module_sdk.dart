import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutrition_ai/nutrition_ai.dart';

import 'common/connectors/local_db_connector.dart';
import 'common/connectors/passio_connector.dart';
import 'common/constant/app_constants.dart';
import 'common/locale/app_localizations.dart';
import 'common/util/database_helper.dart';
import 'common/util/preference_store.dart';
import 'common/util/string_extensions.dart';
import 'common/widgets/nutrition_ai_widget.dart';
import 'nutrition_ai_module_configuration.dart';

class NutritionAIModule {
  /// Here, implementing the code for singleton class.
  ///
  static final NutritionAIModule _instance =
      NutritionAIModule._privateConstructor();

  NutritionAIModule._privateConstructor();

  static NutritionAIModule get instance => _instance;

  /// [configuration] holds the key & connector data.
  ///
  var configuration = NutritionConfiguration(connector: LocalDBConnector());

  /// [setPassioKey] function accepts a string key to configure the SDK.
  ///
  NutritionAIModule setPassioKey(String key) {
    configuration = configuration.copyWith(key: key);
    return this;
  }

  /// [setPassioConnector] function is used to establish communication with storage by taking a Passio connector as its parameter.
  ///
  NutritionAIModule setPassioConnector(PassioConnector passioConnector) {
    configuration = configuration.copyWith(connector: passioConnector);
    return this;
  }

  /// [launch] function requires a [BuildContext] parameter to initiate the Nutrition AI module.
  ///
  Future<void> launch(BuildContext context) async {
    assert(
        configuration.key.isNotNullOrEmpty, 'Passio key should not be empty.');

    final passioConfig = PassioConfiguration(configuration.key ?? '');
    final passioStatus = await NutritionAI.instance.configureSDK(passioConfig);

    if (passioStatus.mode != PassioMode.isReadyForDetection) {
      return;
    }
    // Checking the type of connector and based on that will peform the operator.
    // If user passes the connector to the configuration then we will not initialize the Database
    // Else we have to initialize the local database.
    //
    if (configuration.connector is LocalDBConnector) {
      await DatabaseHelper.instance.init();
    }

    // Set preferred device orientation to portrait mode
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    // Load language file for localization
    await AppLocalizations.instance.loadLanguageFile(
        'packages/${AppCommonConstants.packageName}/assets/translation/app_en.json');

    await PreferenceStore.instance.init();

    // Check if the current widget is mounted before proceeding
    if (context.mounted) {
      // Initialize ScreenUtil for responsive UI
      ScreenUtil.init(
        context,
        designSize: Size(AppDimens.designWidth, AppDimens.designHeight),
      );

      // Navigate to the NutritionAIWidget screen
      NutritionAIWidget.navigate(context);
    }
  }
}
