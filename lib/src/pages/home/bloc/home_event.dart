part of 'home_bloc.dart';

/// Abstract base class for events related to the HomeBloc.
/// All events should extend this class and override the `props` method.
abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class FetchRecordsEvent extends HomeEvent {
  final DateTime dateTime;

  const FetchRecordsEvent({required this.dateTime});

  @override
  List<Object?> get props => [dateTime];
}
