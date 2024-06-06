part of 'water_bloc.dart';

sealed class WaterState extends Equatable {
  const WaterState();
}

final class WaterInitial extends WaterState {
  const WaterInitial();

  @override
  List<Object> get props => [];
}

class FetchRecordsSuccessState extends WaterState {
  const FetchRecordsSuccessState({this.rangeDates, this.dayLogs});

  final RangeDates? rangeDates;
  final WaterDayLogs? dayLogs;

  @override
  List<Object?> get props => [rangeDates, dayLogs];
}

class QuickAddSuccessState extends WaterState {
  const QuickAddSuccessState();

  @override
  List<Object?> get props => [];
}

final class DeleteLogSuccessState extends WaterState {
  const DeleteLogSuccessState();

  @override
  List<Object?> get props => [];
}
