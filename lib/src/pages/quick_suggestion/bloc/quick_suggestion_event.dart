part of 'quick_suggestion_bloc.dart';

sealed class QuickSuggestionEvent extends Equatable {
  const QuickSuggestionEvent();
}

final class FetchSuggestionsEvent extends QuickSuggestionEvent {
  const FetchSuggestionsEvent();

  @override
  List<Object?> get props => [];
}

final class DoLogEvent extends QuickSuggestionEvent {
  const DoLogEvent({required this.index, required this.suggestion});

  final int index;
  final QuickSuggestion suggestion;

  @override
  List<Object?> get props => [index, suggestion];
}
