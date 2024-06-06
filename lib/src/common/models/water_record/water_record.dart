import '../user_profile/user_profile_model.dart';

/// A class representing a water consumption record.
class WaterRecord {
  /// The unique identifier of the water record.
  int? id;

  /// The amount of water consumed, stored internally in milliliters.
  double _waterConsumption;

  /// The timestamp indicating when the water record was created.
  final int createdAt;

  /// Private constructor for creating a [WaterRecord] instance.
  WaterRecord._(
    this.id,
    this._waterConsumption,
    this.createdAt,
  );

  /// Constructs a [WaterRecord] instance with optional parameters.
  ///
  /// Parameters:
  ///   - [id]: The unique identifier of the water record.
  ///   - [createdAt]: The timestamp indicating when the water record was created. Defaults to 0.
  factory WaterRecord({int? id, int createdAt = 0}) {
    return WaterRecord._(id, 0, createdAt);
  }

  /// Sets the amount of water consumed.
  ///
  /// Parameters:
  ///   - [water]: The amount of water consumed.
  ///   - [unit]: The measurement system used for the water consumption.
  void setWater(double water, MeasurementSystem unit) {
    _waterConsumption = switch (unit) {
      MeasurementSystem.imperial => water / Conversion.mlToOz.value,
      _ => water,
    };
  }

  /// Retrieves the amount of water consumed.
  ///
  /// Parameters:
  ///   - [unit]: The measurement system used for retrieving the water consumption. Defaults to [MeasurementSystem.metric].
  ///
  /// Returns:
  ///   The amount of water consumed, optionally converted based on the specified [unit].
  double getWater({MeasurementSystem? unit}) {
    return switch (unit) {
      MeasurementSystem.imperial =>
        (_waterConsumption * Conversion.mlToOz.value),
      _ => _waterConsumption,
    };
  }

  /// Constructs a [WaterRecord] instance from a JSON map.
  factory WaterRecord.fromJson(Map<String, dynamic> json) => WaterRecord._(
        json['id'],
        (json['data'] as num).toDouble(),
        json['created_at'],
      );

  /// Converts the [WaterRecord] instance to a JSON map.
  Map<String, dynamic> toJson() => {
        'id': id,
        'data': _waterConsumption,
        'created_at': createdAt,
      };

  /// Overrides the equality operator.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WaterRecord &&
        other.id == id &&
        other._waterConsumption == _waterConsumption &&
        other.createdAt == createdAt;
  }

  /// Overrides the hashCode method.
  @override
  int get hashCode => Object.hash(
        id,
        _waterConsumption,
        createdAt,
      );

  /// Creates a copy of the [WaterRecord] instance with optional parameter overrides.
  ///
  /// Parameters:
  ///   - [id]: The unique identifier of the water record.
  ///   - [waterConsumption]: The amount of water consumed.
  ///   - [createdAt]: The timestamp indicating when the water record was created.
  ///
  /// Returns:
  ///   A new [WaterRecord] instance with the specified overrides.
  WaterRecord copyWith({
    int? id,
    double? waterConsumption,
    int? createdAt,
  }) {
    return WaterRecord._(
      id ?? this.id,
      waterConsumption ?? _waterConsumption,
      createdAt ?? this.createdAt,
    );
  }
}
