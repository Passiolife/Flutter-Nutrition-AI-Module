import 'package:flutter/foundation.dart';

import 'common/connectors/passio_connector.dart';

@protected
class NutritionConfiguration {
  /// [_key] accepts a string key to configure the SDK.
  ///
  final String? key;

  /// [_connector] is used to establish communication with storage by taking a Passio connector as its parameter.
  ///
  final PassioConnector connector;

  const NutritionConfiguration({required this.connector, this.key});

  copyWith({String? key, PassioConnector? connector, String? databaseName}) {
    return NutritionConfiguration(connector: connector ?? this.connector, key: key ?? this.key);
  }
}
