part of 'water_bloc.dart';

sealed class WaterEvent extends Equatable {
  const WaterEvent();
}

final class UpdateTabEvent extends WaterEvent {
  const UpdateTabEvent(this.tab);

  final int tab;

  @override
  List<Object> get props => [tab];
}

final class UpdatePageEvent extends WaterEvent {
  const UpdatePageEvent(this.page);

  final int page;

  @override
  List<Object> get props => [page];
}

final class UpdateQuickAddEvent extends WaterEvent {
  const UpdateQuickAddEvent();

  @override
  List<Object> get props => [];
}

final class UpdateDateRangeEvent extends WaterEvent {
  const UpdateDateRangeEvent({
    required this.startDate,
    required this.endDate,
  });

  final DateTime startDate;
  final DateTime endDate;

  @override
  List<Object?> get props => [startDate, endDate];
}

final class FetchRecordsEvent extends WaterEvent {
  const FetchRecordsEvent();

  @override
  List<Object?> get props => [];
}

final class FetchRecordsFailureEvent extends WaterEvent {
  const FetchRecordsFailureEvent({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}

final class QuickAddEvent extends WaterEvent {
  const QuickAddEvent({required this.consumedWater});

  final double consumedWater;

  @override
  List<Object?> get props => [consumedWater];
}

final class QuickAddSuccessEvent extends WaterEvent {
  const QuickAddSuccessEvent();

  @override
  List<Object?> get props => [];
}

final class QuickAddFailureEvent extends WaterEvent {
  const QuickAddFailureEvent({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}

final class UpdateWaterTrendEvent extends WaterEvent {
  const UpdateWaterTrendEvent();

  @override
  List<Object?> get props => [];
}

final class DeleteWaterEvent extends WaterEvent {
  const DeleteWaterEvent({required this.record});

  final WaterRecord record;

  @override
  List<Object?> get props => [record];
}

final class DeleteWaterFailureEvent extends WaterEvent {
  const DeleteWaterFailureEvent({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}

final class UpdateRecordsEvent extends WaterEvent {
  const UpdateRecordsEvent();


  @override
  List<Object?> get props => [];
}