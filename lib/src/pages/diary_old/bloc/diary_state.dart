part of 'diary_bloc.dart';

abstract class DiaryState extends Equatable {
  const DiaryState();
}

class DiaryInitial extends DiaryState {
  @override
  List<Object> get props => [];
}

class FetchRecordsSuccessState extends DiaryState {
  final DayLog dayLog;

  const FetchRecordsSuccessState(this.dayLog);

  @override
  List<Object?> get props => [dayLog];
}

class RecordDeletedSuccessState extends DiaryState {
  final String id;

  const RecordDeletedSuccessState({required this.id});

  @override
  List<Object?> get props => [id];
}

final class FetchSuggestionsSuccessState extends DiaryState {
  final List<QuickSuggestion> data;

  const FetchSuggestionsSuccessState({required this.data});

  @override
  List<Object?> get props => [data];
}

final class LogSuccessState extends DiaryState {
  const LogSuccessState({required this.createdAt});
  final int createdAt;

  @override
  List<Object?> get props => [createdAt];
}
