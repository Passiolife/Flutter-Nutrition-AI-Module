part of 'my_foods_bloc.dart';

sealed class MyFoodsEvent extends Equatable {
  const MyFoodsEvent();
}

final class TabChangeEvent extends MyFoodsEvent {
  const TabChangeEvent({required this.page});

  final int page;

  @override
  List<Object> get props => [page];
}

final class PageChangeEvent extends MyFoodsEvent {
  const PageChangeEvent({required this.page});

  final int page;

  @override
  List<Object> get props => [page];
}