part of 'add_water_bloc.dart';

sealed class AddWaterState extends Equatable {
  const AddWaterState();
}

final class AddWaterInitial extends AddWaterState {
  const AddWaterInitial();

  @override
  List<Object> get props => [];
}

final class SaveSuccessState extends AddWaterState {
  const SaveSuccessState({required this.record});

  final WaterRecord record;

  @override
  List<Object> get props => [record];
}

final class SaveFailureState extends AddWaterState {
  const SaveFailureState({required this.timestamp});

  final int timestamp;

  @override
  List<Object> get props => [timestamp];
}
