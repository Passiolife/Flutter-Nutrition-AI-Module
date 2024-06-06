part of 'micros_bloc.dart';

sealed class MicrosEvent extends Equatable {
  const MicrosEvent();
}

final class DoFetchRecordsEvent extends MicrosEvent {
  const DoFetchRecordsEvent({required this.selectedDateTime});
  final DateTime selectedDateTime;

  @override
  List<Object?> get props => [selectedDateTime];
}
