part of 'weight_bloc.dart';

sealed class WeightEvent extends Equatable {
  const WeightEvent();
}

final class UpdateTabEvent extends WeightEvent {
  const UpdateTabEvent(this.tab);

  final int tab;

  @override
  List<Object> get props => [tab];
}

final class UpdatePageEvent extends WeightEvent {
  const UpdatePageEvent(this.page);

  final int page;

  @override
  List<Object> get props => [page];
}