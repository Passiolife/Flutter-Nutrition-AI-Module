part of 'diary_bloc.dart';

abstract class DiaryEvent extends Equatable {
  const DiaryEvent();
}

class DoLogEditEvent extends DiaryEvent {
  @override
  List<Object?> get props => [];
}

class DoLogDeleteEvent extends DiaryEvent {
  @override
  List<Object?> get props => [];
}

class FetchRecordsEvent extends DiaryEvent {
  final DateTime dateTime;

  const FetchRecordsEvent({required this.dateTime});

  @override
  List<Object?> get props => [dateTime];
}
