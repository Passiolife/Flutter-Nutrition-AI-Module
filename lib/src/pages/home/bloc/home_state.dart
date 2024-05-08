part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  const HomeInitial();

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
  final DateTime selectedDateTime;
  final DayLogs? dayLogs;
  final RangeDates? rangeDates;
  final DayLog? dayLog;
  final CalendarFormat format;
  final double consumedWater;
  final double measuredWeight;
  final bool needToUpdateSelectedDayLog;

  const FetchRecordsSuccessState({
    required this.selectedDateTime,
    required this.format,
    this.dayLogs,
    this.rangeDates,
    this.dayLog,
    required this.consumedWater,
    required this.measuredWeight,
    this.needToUpdateSelectedDayLog = true,
  });

  @override
  List<Object?> get props => [
        selectedDateTime,
        dayLogs,
        rangeDates,
        dayLog,
        format,
        consumedWater,
        measuredWeight,
      ];
}

class CalendarFormatSuccessState extends HomeState {
  const CalendarFormatSuccessState({required this.format});

  final CalendarFormat format;

  @override
  List<Object?> get props => [format];
}
