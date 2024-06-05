part of 'macros_bloc.dart';

sealed class MacrosEvent extends Equatable {
  const MacrosEvent();
}

final class DoTabChangeEvent extends MacrosEvent {
  const DoTabChangeEvent({required this.tab});

  final String tab;

  @override
  List<Object?> get props => [];
}

final class DoFetchRecordsEvent extends MacrosEvent {
  const DoFetchRecordsEvent(
      {required this.selectedDateTime, required this.isMonth});
  final DateTime selectedDateTime;
  final bool isMonth;

  @override
  List<Object?> get props => [selectedDateTime, isMonth];
}
