part of 'progress_bloc.dart';

abstract class ProgressState {}

class ProgressInitial extends ProgressState {

}

class TimeUpdateSuccessState extends ProgressState {
  final List<TimeLog> data;
  final TimeEnum? selectedTimeEnum;
  final int selectedDays;

  TimeUpdateSuccessState({required this.data, required this.selectedDays, required this.selectedTimeEnum});
}
class TimeUpdateFailureState extends ProgressState {
  final String message;

  TimeUpdateFailureState({required this.message});
}