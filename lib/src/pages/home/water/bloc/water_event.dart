part of 'water_bloc.dart';

sealed class WaterEvent extends Equatable {
  const WaterEvent();
}

final class FetchRecordsEvent extends WaterEvent {
  const FetchRecordsEvent({
    required this.dateTime,
    required this.isMonth,
  });

  final DateTime dateTime;
  final bool isMonth;

  @override
  List<Object?> get props => [dateTime, isMonth];
}

final class QuickAddEvent extends WaterEvent {
  const QuickAddEvent({
    required this.consumedWater,
    required this.unit,
  });

  final MeasurementSystem unit;
  final double consumedWater;

  @override
  List<Object?> get props => [consumedWater];
}

final class DoDeleteLogEvent extends WaterEvent {
  const DoDeleteLogEvent({required this.record});

  final WaterRecord record;

  @override
  List<Object?> get props => [record];
}
