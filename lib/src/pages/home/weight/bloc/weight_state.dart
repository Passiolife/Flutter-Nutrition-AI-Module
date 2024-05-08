part of 'weight_bloc.dart';

sealed class WeightState extends Equatable{
  const WeightState();
}

final class WeightInitial extends WeightState {
  const WeightInitial();
  @override
  List<Object?> get props => [];
}

final class FetchRecordsSuccessState extends WeightState {
  const FetchRecordsSuccessState({this.rangeDates, this.dayLogs});

  final RangeDates? rangeDates;
  final WeightDayLogs? dayLogs;

  @override
  List<Object?> get props => [rangeDates, dayLogs];
}

final class DeleteLogSuccessState extends WeightState {
  const DeleteLogSuccessState();

  @override
  List<Object?> get props => [];
}