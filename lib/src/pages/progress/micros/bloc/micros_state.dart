part of 'micros_bloc.dart';

sealed class MicrosState extends Equatable {
  const MicrosState();
}

final class MicrosInitial extends MicrosState {
  const MicrosInitial();

  @override
  List<Object> get props => [];
}

// MicrosListenerState
sealed class MicrosListenerState extends MicrosState {
  const MicrosListenerState();
}

final class FetchRecordsSuccessListenState extends MicrosListenerState {
  final DayLog dayLog;

  const FetchRecordsSuccessListenState(this.dayLog);

  @override
  List<Object?> get props => [dayLog];
}

// MicrosBuilderState
sealed class MicrosBuilderState extends MicrosState {
  const MicrosBuilderState();
}

final class FetchRecordsSuccessBuildState extends MicrosBuilderState {
  const FetchRecordsSuccessBuildState();

  @override
  List<Object?> get props => [];
}
