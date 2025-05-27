part of 'add_water_bloc.dart';

sealed class AddWaterEvent extends Equatable {
  const AddWaterEvent();
}

final class InitialEvent extends AddWaterEvent {
  const InitialEvent();

  @override
  List<Object?> get props => [];
}

final class UpdateWaterRecordEvent extends AddWaterEvent {
  const UpdateWaterRecordEvent({required this.record});

  final WaterRecord record;

  @override
  List<Object?> get props => [record];
}

final class UpdateWaterEvent extends AddWaterEvent {
  const UpdateWaterEvent({required this.water});

  final String water;

  @override
  List<Object?> get props => [water];
}

final class UpdateDayEvent extends AddWaterEvent {
  const UpdateDayEvent({required this.date});

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

final class UpdateTimeEvent extends AddWaterEvent {
  const UpdateTimeEvent({required this.time});

  final TimeOfDay time;

  @override
  List<Object?> get props => [time];
}

final class SaveEvent extends AddWaterEvent {
  const SaveEvent();

  @override
  List<Object?> get props => [];
}

final class SaveSuccessEvent extends AddWaterEvent {
  const SaveSuccessEvent();

  @override
  List<Object?> get props => [];
}

final class SaveFailureEvent extends AddWaterEvent {
  const SaveFailureEvent({required this.error});
  final String error;

  @override
  List<Object?> get props => [error];
}