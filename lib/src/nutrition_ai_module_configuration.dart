import 'package:flutter/foundation.dart';

import 'common/connectors/passio_connector.dart';

/// The `NutritionConfiguration` class holds the configuration data for the Nutrition AI module,
/// including the connector used to establish communication with the storage.
@protected
class NutritionConfiguration {
  /// The [connector] is used to establish communication with storage by taking a Passio connector as its parameter.
  ///
  /// This field is required and is used to interact with the storage backend.
  final PassioConnector connector;

  /// Constructor for creating a `NutritionConfiguration` instance.
  ///
  /// Takes a [PassioConnector] as a required named parameter to initialize the configuration.
  const NutritionConfiguration({required this.connector});

  /// Creates a copy of the current `NutritionConfiguration` instance with optional modifications.
  ///
  /// The [connector] parameter can be provided to override the existing connector.
  ///
  /// Returns a new `NutritionConfiguration` instance with the updated values.
  NutritionConfiguration copyWith({PassioConnector? connector}) {
    return NutritionConfiguration(connector: connector ?? this.connector);
  }
}
