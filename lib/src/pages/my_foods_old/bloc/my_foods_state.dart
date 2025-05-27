part of 'my_foods_bloc.dart';

sealed class MyFoodsState extends Equatable {
  const MyFoodsState();
}

final class MyFoodsInitial extends MyFoodsState {
  const MyFoodsInitial();

  @override
  List<Object> get props => [];
}

// Listeners
sealed class ListenerState extends MyFoodsState {
  const ListenerState();
}

// Builders
sealed class BuilderState extends MyFoodsState {
  const BuilderState();
}
