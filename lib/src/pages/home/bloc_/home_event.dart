part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();
}

final class HomeInitialEvent extends HomeEvent {
  const HomeInitialEvent();

  @override
  List<Object?> get props => [];
}

final class UpdateDateEvent extends HomeEvent {
  const UpdateDateEvent(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

final class FetchRecordsEvent extends HomeEvent {
  const FetchRecordsEvent();

  @override
  List<Object?> get props => [];
}

final class UpdateWaterEvent extends HomeEvent {
  const UpdateWaterEvent();

  @override
  List<Object?> get props => [];
}

final class UpdateWeightEvent extends HomeEvent {
  const UpdateWeightEvent();

  @override
  List<Object?> get props => [];
}

final class UpdateDailyNutritionEvent extends HomeEvent {
  const UpdateDailyNutritionEvent();

  @override
  List<Object?> get props => [];
}

final class UpdateWeeklyAdherenceEvent extends HomeEvent {
  const UpdateWeeklyAdherenceEvent({
    required this.focusedDate,
    required this.startDate,
    required this.endDate,
  });

  final DateTime focusedDate;
  final DateTime startDate;
  final DateTime endDate;

  @override
  List<Object?> get props => [focusedDate, startDate, endDate];
}
