part of 'voice_logging_bloc.dart';

sealed class VoiceLoggingState extends Equatable {
  const VoiceLoggingState();
}

final class VoiceLoggingInitial extends VoiceLoggingState {
  const VoiceLoggingInitial();

  @override
  List<Object> get props => [];
}

// Listeners
sealed class ListenerState extends VoiceLoggingState {
  const ListenerState();
}

final class ErrorListenerState extends ListenerState {
  const ErrorListenerState(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}

final class VoiceLogsRecognitionErrorListenerState extends ListenerState {
  const VoiceLogsRecognitionErrorListenerState();

  @override
  List<Object?> get props => [];
}

final class FoodLogSuccessListenerState extends ListenerState {
  const FoodLogSuccessListenerState();

  @override
  List<Object?> get props => [];
}

final class FoodLogFailureListenerState extends ListenerState {
  const FoodLogFailureListenerState();

  @override
  List<Object?> get props => [];
}

// Builders
sealed class BuilderState extends VoiceLoggingState {
  const BuilderState();
}

final class RecognizeBuilderState extends BuilderState {
  const RecognizeBuilderState({required this.recognizeWords});

  final String recognizeWords;

  @override
  List<Object?> get props => [recognizeWords];
}

final class ListenerStateStoppedBuilder extends BuilderState {
  const ListenerStateStoppedBuilder();

  @override
  List<Object?> get props => [];
}

final class RecognizeVoiceLogsSuccessState extends BuilderState {
  const RecognizeVoiceLogsSuccessState({this.data});

  final List<VoiceLog>? data;

  @override
  List<Object?> get props => [data];
}

final class UpdateRecognizeVoiceLogsState extends BuilderState {
  const UpdateRecognizeVoiceLogsState({this.data, required this.timeStamp});

  final List<VoiceLog>? data;
  final int timeStamp;

  @override
  List<Object?> get props => [timeStamp, data];
}

final class FoodLogLoadingBuilderState extends BuilderState {
  const FoodLogLoadingBuilderState({required this.isLogLoading, this.data});

  final bool isLogLoading;
  final List<VoiceLog>? data;

  @override
  List<Object?> get props => [isLogLoading, data];
}

final class ListeningUpdateBuilderState extends BuilderState {
  const ListeningUpdateBuilderState({required this.isListening});

  final bool isListening;

  @override
  List<Object?> get props => [isListening];
}

final class ProcessingUpdateBuilderState extends BuilderState {
  const ProcessingUpdateBuilderState({required this.isProcessing});

  final bool isProcessing;

  @override
  List<Object?> get props => [isProcessing];
}

final class NoResultsBuilderState extends BuilderState {
  const NoResultsBuilderState();

  @override
  List<Object?> get props => [DateTime.timestamp()];
}

final class TryAgainSuccessState extends BuilderState {
  const TryAgainSuccessState();

  @override
  List<Object?> get props => [];
}
