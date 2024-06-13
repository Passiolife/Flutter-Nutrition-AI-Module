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

final class ListenerStateStarted extends ListenerState {
  const ListenerStateStarted();

  @override
  List<Object?> get props => [];
}

final class RecognizeListenerState extends ListenerState {
  const RecognizeListenerState(this.words);

  final String words;

  @override
  List<Object?> get props => [words];
}

final class ListenerStateStopped extends ListenerState {
  const ListenerStateStopped();

  @override
  List<Object?> get props => [];
}

final class VoiceLogsRecognitionSuccessListenerState extends ListenerState {
  final List<VoiceLog>? data;

  const VoiceLogsRecognitionSuccessListenerState({required this.data});

  @override
  List<Object?> get props => [data];
}

final class VoiceLogsRecognitionErrorListenerState extends ListenerState {
  const VoiceLogsRecognitionErrorListenerState();

  @override
  List<Object?> get props => [];
}

final class FoodLogLoadingListenerState extends ListenerState {
  const FoodLogLoadingListenerState();

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
  const RecognizeBuilderState();

  @override
  List<Object?> get props => [];
}

final class ListenerStateStoppedBuilder extends BuilderState {
  const ListenerStateStoppedBuilder();

  @override
  List<Object?> get props => [];
}

final class RecognizeVoiceLogsBuilderState extends BuilderState {
  const RecognizeVoiceLogsBuilderState();

  @override
  List<Object?> get props => [];
}

final class UpdateSelectionBuilderState extends BuilderState {
  const UpdateSelectionBuilderState();

  @override
  List<Object?> get props => [];
}


final class FoodLogLoadingBuilderState extends BuilderState {
  const FoodLogLoadingBuilderState();

  @override
  List<Object?> get props => [];
}