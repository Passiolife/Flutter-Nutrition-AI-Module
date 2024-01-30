import 'package:flutter/foundation.dart';

import 'common/connectors/passio_connector.dart';

/// Configuration class for setting up nutrition-related SDK parameters.
@protected
class NutritionConfiguration {
  /// [_key] accepts a string key to configure the SDK.
  ///
  final String? key;

  /// [_connector] is used to establish communication with storage by taking a Passio connector as its parameter.
  ///
  final PassioConnector connector;

  /// Constructs a [NutritionConfiguration] with the specified [connector] and optional [key].
  const NutritionConfiguration({required this.connector, this.key});

  /// Creates a new [NutritionConfiguration] with the specified values, allowing for partial updates.
  NutritionConfiguration copyWith({String? key, PassioConnector? connector}) {
    return NutritionConfiguration(
        connector: connector ?? this.connector, key: key ?? this.key);
  }
}
