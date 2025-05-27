part of 'quick_suggestion_bloc.dart';

sealed class QuickSuggestionState extends Equatable {
  const QuickSuggestionState();
}

final class InitialState extends QuickSuggestionState {
  const InitialState();

  @override
  List<Object?> get props => [];
}

final class FetchSuggestionsErrorState extends QuickSuggestionState {
  const FetchSuggestionsErrorState({required this.errorMessage});
  final String errorMessage;

  @override
  List<Object?> get props => [errorMessage];
}

final class FetchSuggestionsSuccessState extends QuickSuggestionState {
  const FetchSuggestionsSuccessState({required this.data});
  final List<QuickSuggestion> data;

  @override
  List<Object?> get props => [data];
}

