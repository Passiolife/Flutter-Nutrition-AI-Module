part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class DateUpdateState extends HomeState {
  final DateTime newDate;

  const DateUpdateState({required this.newDate});

  @override
  List<Object?> get props => [newDate];
}

class FetchRecordsSuccessState extends HomeState {
  final DayLogs dayLogs;

  const FetchRecordsSuccessState(this.dayLogs);

  @override
  List<Object?> get props => [dayLogs];
}
