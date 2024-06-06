part of 'home_bloc.dart';

/// Abstract base class for events related to the HomeBloc.
/// All events should extend this class and override the `props` method.
abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class FetchRecordsEvent extends HomeEvent {
  final DateTime dateTime;
  final MeasurementSystem? weightUnit;
  final bool needToUpdateSelectedDayLog;

  const FetchRecordsEvent(
      {required this.dateTime,
      this.weightUnit,
      this.needToUpdateSelectedDayLog = true});

  @override
  List<Object?> get props => [dateTime, weightUnit];
}

class UpdateCalendarFormatEvent extends HomeEvent {
  final DateTime dateTime;
  final MeasurementSystem? weightUnit;

  const UpdateCalendarFormatEvent({required this.dateTime, this.weightUnit});

  @override
  List<Object?> get props => [dateTime, weightUnit];
}
