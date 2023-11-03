import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'common/connectors/local_db_connector.dart';
import 'common/connectors/passio_connector.dart';
import 'common/constant/app_constants.dart';
import 'common/constant/dimens.dart';
import 'common/util/database_helper.dart';
import 'common/util/string_extensions.dart';
import 'locale/app_localizations.dart';
import 'nutrition_ai_module_configuration.dart';
import 'pages/splash/splash_page.dart';

class NutritionAIModule {
  /// Here, implementing the code for singleton class.
  ///
  static final NutritionAIModule _instance = NutritionAIModule._privateConstructor();

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
  Future launch(BuildContext context) async {
    assert(configuration.key.isNotNullOrEmpty, 'Passio key should not be empty.');

    /// Checking the type of connector and based on that will peform the operator.
    /// If user passes the connector to the configuration then we will not initialize the Database
    /// Else we have to initialize the local database.
    ///
    if (configuration.connector is LocalDBConnector) {
      DatabaseHelper.instance.init();
    }

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    /// Launching the [Main] to set up the module.
    ///
    if (context.mounted) {
      AppLocalizations.instance.loadLanguageFile('packages/${AppConstants.packageName}/assets/translation/app_en.json');
      ScreenUtil.init(context, designSize: const Size(Dimens.designWidth, Dimens.designHeight));
      SplashPage.navigate(context);
    }
  }
}
