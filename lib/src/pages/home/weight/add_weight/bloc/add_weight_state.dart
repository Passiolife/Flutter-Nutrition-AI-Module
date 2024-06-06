part of 'add_weight_bloc.dart';

sealed class AddWeightState extends Equatable {
  const AddWeightState();
}

final class AddWaterInitial extends AddWeightState {
  const AddWaterInitial();

  @override
  List<Object> get props => [];
}

final class SaveSuccessState extends AddWeightState {
  const SaveSuccessState({required this.record});

  final WeightRecord record;

  @override
  List<Object> get props => [record];
}

final class SaveFailureState extends AddWeightState {
  const SaveFailureState({required this.timestamp});

  final int timestamp;

  @override
  List<Object> get props => [timestamp];
}
