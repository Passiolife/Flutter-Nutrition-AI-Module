part of 'macros_bloc.dart';

sealed class MacrosState extends Equatable {
  const MacrosState();
}

final class MacrosInitial extends MacrosState {
  const MacrosInitial();

  @override
  List<Object> get props => [];
}

// MacrosListenerState
sealed class MacrosListenerState extends MacrosState {
  const MacrosListenerState();
}

final class TabChangeListenState extends MacrosListenerState {
  const TabChangeListenState({required this.tab});

  final String tab;

  @override
  List<Object?> get props => [tab];
}

final class FetchRecordsSuccessListenState extends MacrosListenerState {
  const FetchRecordsSuccessListenState(
      {required this.rangeDates, required this.dayLogs});

  final RangeDates? rangeDates;
  final DayLogs dayLogs;

  @override
  List<Object?> get props => [rangeDates, dayLogs];
}

// MacrosBuilderState
sealed class MacrosBuilderState extends MacrosState {
  const MacrosBuilderState();
}

final class TabChangeBuildState extends MacrosBuilderState {
  const TabChangeBuildState();

  @override
  List<Object?> get props => [];
}

final class FetchRecordsSuccessBuildState extends MacrosBuilderState {
  const FetchRecordsSuccessBuildState();

  @override
  List<Object?> get props => [];
}
