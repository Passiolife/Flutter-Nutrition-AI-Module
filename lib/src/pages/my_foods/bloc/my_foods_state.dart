part of 'my_foods_bloc.dart';

sealed class MyFoodsState  extends Equatable {
  const MyFoodsState();
}

final class InitialState extends MyFoodsState {
  const InitialState();

  @override
  List<Object?> get props => [];
}

final class TabChangedState extends MyFoodsState {
  const TabChangedState({required this.page});
  final int page;

  @override
  List<Object?> get props => [page];
}

final class PageChangedState extends MyFoodsState {
  const PageChangedState({required this.page});
  final int page;

  @override
  List<Object?> get props => [page];
}