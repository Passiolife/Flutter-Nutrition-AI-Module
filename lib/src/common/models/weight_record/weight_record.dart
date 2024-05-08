import '../user_profile/user_profile_model.dart';

class WeightRecord {
  final int? id;
  double _weight;
  final int createdAt;

  WeightRecord._(
    this.id,
    this._weight,
    this.createdAt,
  );

  factory WeightRecord({int? id, int createdAt = 0}) {
    return WeightRecord._(id, 0, createdAt);
  }

  void setWeight(double weight, {MeasurementSystem? unit}) {
    _weight = switch (unit) {
      MeasurementSystem.imperial => weight / Conversion.kgToLbs.value,
      _ => weight,
    };
  }

  double getWeight({MeasurementSystem? unit}) {
    return switch (unit) {
      MeasurementSystem.imperial =>
      (_weight * Conversion.kgToLbs.value),
      _ => _weight,
    };
  }

  factory WeightRecord.fromJson(Map<String, dynamic> json) => WeightRecord._(
    json['id'],
    (json['data'] as num).toDouble(),
    json['created_at'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'data': _weight,
    'created_at': createdAt,
  };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WeightRecord &&
        other.id == id &&
        other._weight == _weight &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(id, _weight, createdAt);

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
