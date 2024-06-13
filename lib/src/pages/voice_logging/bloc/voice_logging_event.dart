part of 'voice_logging_bloc.dart';

sealed class VoiceLoggingEvent extends Equatable {
  const VoiceLoggingEvent();
}

final class StartListeningEvent extends VoiceLoggingEvent {
  const StartListeningEvent();

  @override
  List<Object?> get props => [];
}

final class ErrorEvent extends VoiceLoggingEvent {
  const ErrorEvent();

  @override
  List<Object?> get props => [];
}

final class RecognizeEvent extends VoiceLoggingEvent {
  const RecognizeEvent(this.words);

  final String words;

  @override
  List<Object?> get props => [words];
}

final class StopListeningEvent extends VoiceLoggingEvent {
  const StopListeningEvent();

  @override
  List<Object?> get props => [];
}

final class RecognizeSpeechRemoteEvent extends VoiceLoggingEvent {
  const RecognizeSpeechRemoteEvent({required this.text});

  final String text;

  @override
  List<Object?> get props => [text];
}

final class UpdateSelectionEvent extends VoiceLoggingEvent {
  final int index;
  final VoiceLog? voiceLog;

  const UpdateSelectionEvent({required this.index, this.voiceLog});

  @override
  List<Object?> get props => [voiceLog];
}

final class ClearSelectionEvent extends VoiceLoggingEvent {
  const ClearSelectionEvent();

  @override
  List<Object?> get props => [];
}

final class DoFoodLogEvent extends VoiceLoggingEvent {
  const DoFoodLogEvent();

  @override
  List<Object?> get props => [];
}

final class DoCancelEvent extends VoiceLoggingEvent {
  const DoCancelEvent();

  @override
  List<Object?> get props => [];
}
