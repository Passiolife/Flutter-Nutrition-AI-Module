part of 'weight_bloc.dart';

sealed class WeightState  extends Equatable {
  const WeightState();
}

final class InitialState extends WeightState {
  const InitialState();

  @override
  List<Object?> get props => [];
}

final class UpdateTabState extends WeightState {
  const UpdateTabState({required this.tab});

  final int tab;

  @override
  List<Object?> get props => [tab];
}

final class UpdatePageState extends WeightState {
  const UpdatePageState({required this.page});

  final int page;

  @override
  List<Object?> get props => [page];
}