part of 'add_water_bloc.dart';

sealed class AddWaterEvent extends Equatable {
  const AddWaterEvent();
}

class SaveWaterEvent extends AddWaterEvent {
  const SaveWaterEvent({
    this.id,
    required this.consumedWater,
    required this.unit,
    required this.createdAt,
    required this.isNew,
  });

  final int? id;
  final String consumedWater;
  final MeasurementSystem unit;
  final DateTime createdAt;
  final bool isNew;

  @override
  List<Object?> get props => [consumedWater, unit, createdAt, isNew];
}
