part of 'progress_bloc.dart';

sealed class ProgressState extends Equatable {
  const ProgressState();
}

final class ProgressInitial extends ProgressState {
  @override
  List<Object> get props => [];
}
