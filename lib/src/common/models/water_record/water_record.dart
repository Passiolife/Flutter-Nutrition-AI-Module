import '../user_profile/user_profile_model.dart';

class WaterRecord {
  final int? id;
  double _waterConsumption;
  final int createdAt;

  WaterRecord._(
    this.id,
    this._waterConsumption,
    this.createdAt,
  );

  factory WaterRecord({int? id, int createdAt = 0}) {
    return WaterRecord._(id, 0, createdAt);
  }

  void setWater(double water, MeasurementSystem unit) {
    _waterConsumption = switch (unit) {
      MeasurementSystem.imperial => water / Conversion.mlToOz.value,
      _ => water,
    };
  }

  double getWater({MeasurementSystem? unit}) {
    return switch (unit) {
      MeasurementSystem.imperial =>
        (_waterConsumption * Conversion.mlToOz.value),
      _ => _waterConsumption,
    };
  }

  factory WaterRecord.fromJson(Map<String, dynamic> json) => WaterRecord._(
        json['id'],
        (json['data'] as num).toDouble(),
        json['created_at'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'data': _waterConsumption,
        'created_at': createdAt,
      };

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WaterRecord &&
        other.id == id &&
        other._waterConsumption == _waterConsumption &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(id, _waterConsumption, createdAt);

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
