part of 'weight_bloc.dart';

sealed class WeightEvent extends Equatable {
  const WeightEvent();
}

final class FetchRecordsEvent extends WeightEvent {
  const FetchRecordsEvent({
    required this.dateTime,
    required this.isMonth,
  });

  final DateTime dateTime;
  final bool isMonth;

  @override
  List<Object?> get props => [dateTime, isMonth];
}

final class DoDeleteLogEvent extends WeightEvent {
  const DoDeleteLogEvent({required this.record});

  final WeightRecord record;

  @override
  List<Object?> get props => [record];
}