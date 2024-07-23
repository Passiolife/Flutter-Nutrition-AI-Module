part of 'my_foods_bloc.dart';

sealed class MyFoodsEvent extends Equatable {
  const MyFoodsEvent();
}

final class DoTabChangeEvent extends MyFoodsEvent {
  const DoTabChangeEvent({required this.tab});

  final String tab;

  @override
  List<Object?> get props => [tab];
}
