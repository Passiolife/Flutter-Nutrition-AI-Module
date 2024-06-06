part of 'diary_bloc.dart';

abstract class DiaryEvent extends Equatable {
  const DiaryEvent();
}

final class FetchRecordsEvent extends DiaryEvent {
  final DateTime dateTime;

  const FetchRecordsEvent({required this.dateTime});

  @override
  List<Object?> get props => [dateTime];
}

final class DoRecordDeleteEvent extends DiaryEvent {
  final FoodRecord foodRecord;

  const DoRecordDeleteEvent({required this.foodRecord});

  @override
  List<Object?> get props => [foodRecord];
}

final class FetchSuggestionsEvent extends DiaryEvent {
  const FetchSuggestionsEvent();

  @override
  List<Object?> get props => [];
}

// Event will add the data into log.
class DoLogEvent extends DiaryEvent {
  const DoLogEvent({this.data});

  final QuickSuggestion? data;

  @override
  List<Object?> get props => [data];
}
