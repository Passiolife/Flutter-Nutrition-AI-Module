part of 'progress_bloc.dart';

abstract class ProgressEvent {}

class DoCalendarChangeEvent extends ProgressEvent {
  final String? time;

  DoCalendarChangeEvent({required this.time});
}

class GetAllFoodDataEvent extends ProgressEvent {}
