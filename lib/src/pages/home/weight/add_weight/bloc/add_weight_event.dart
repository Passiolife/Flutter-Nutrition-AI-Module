part of 'add_weight_bloc.dart';

sealed class AddWeightEvent extends Equatable {
  const AddWeightEvent();
}

class SaveWaterEvent extends AddWeightEvent {
  const SaveWaterEvent({
    this.id,
    required this.weightMeasurement,
    this.unit,
    required this.createdAt,
    required this.isNew,
  });

  final int? id;
  final String weightMeasurement;
  final MeasurementSystem? unit;
  final DateTime createdAt;
  final bool isNew;

  @override
  List<Object?> get props => [id, weightMeasurement, unit, createdAt, isNew];
}
