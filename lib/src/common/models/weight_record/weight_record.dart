import '../user_profile/user_profile_model.dart';

/// A class representing a weight record.
class WeightRecord {
  /// The unique identifier for the weight record.
  int? id;

  /// The weight value.
  double _weight;

  /// The timestamp indicating when the weight record was created.
  final int createdAt;

  /// Constructs a [WeightRecord] instance with the specified parameters.
  ///
  /// Parameters:
  ///   - [id]: The unique identifier for the weight record.
  ///   - [createdAt]: The timestamp indicating when the weight record was created. Defaults to 0.
  WeightRecord._(
    this.id,
    this._weight,
    this.createdAt,
  );

  /// Constructs a [WeightRecord] instance with the specified parameters.
  ///
  /// Parameters:
  ///   - [id]: The unique identifier for the weight record.
  ///   - [createdAt]: The timestamp indicating when the weight record was created. Defaults to 0.
  factory WeightRecord({int? id, int createdAt = 0}) {
    return WeightRecord._(id, 0, createdAt);
  }

  /// Sets the weight value.
  ///
  /// Parameters:
  ///   - [weight]: The weight value to be set.
  ///   - [unit]: The measurement system used for setting the weight. Defaults to null, indicating the default measurement system.
  void setWeight(double weight, {MeasurementSystem? unit}) {
    _weight = switch (unit) {
      MeasurementSystem.imperial => weight / Conversion.kgToLbs.value,
      _ => weight,
    };
  }

  /// Retrieves the weight value.
  ///
  /// Parameters:
  ///   - [unit]: The measurement system used for retrieving the weight. Defaults to null, indicating the default measurement system.
  ///
  /// Returns:
  ///   The weight value, optionally converted based on the specified [unit].
  double getWeight({MeasurementSystem? unit}) {
    return switch (unit) {
      MeasurementSystem.imperial => (_weight * Conversion.kgToLbs.value),
      _ => _weight,
    };
  }

  /// Constructs a [WeightRecord] instance from a JSON object.
  ///
  /// Parameters:
  ///   - [json]: A JSON object representing the weight record.
  factory WeightRecord.fromJson(Map<String, dynamic> json) => WeightRecord._(
        json['id'],
        (json['data'] as num).toDouble(),
        json['created_at'],
      );

  /// Converts the weight record instance to a JSON object.
  ///
  /// Returns:
  ///   A JSON representation of the weight record instance.
  Map<String, dynamic> toJson() => {
        'id': id,
        'data': _weight,
        'created_at': createdAt,
      };

  /// Overrides the equality operator.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeightRecord &&
        other.id == id &&
        other._weight == _weight &&
        other.createdAt == createdAt;
  }

  /// Overrides the hashCode method.
  @override
  int get hashCode => Object.hash(
        id,
        _weight,
        createdAt,
      );

  /// Creates a copy of the current weight record with the specified attributes overridden.
  ///
  /// Parameters:
  ///   - [id]: The unique identifier for the weight record.
  ///   - [weight]: The weight value.
  ///   - [createdAt]: The timestamp indicating when the weight record was created.
  ///
  /// Returns:
  ///   A new [WeightRecord] instance with the specified attributes overridden.
  WeightRecord copyWith({
    int? id,
    double? weight,
    int? createdAt,
  }) {
    return WeightRecord._(
      id ?? this.id,
      weight ?? _weight,
      createdAt ?? this.createdAt,
    );
  }
}
