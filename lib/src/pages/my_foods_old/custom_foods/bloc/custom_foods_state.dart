part of 'custom_foods_bloc.dart';

sealed class CustomFoodsState extends Equatable {
  const CustomFoodsState();
}

final class CustomFoodsInitial extends CustomFoodsState {
  @override
  List<Object> get props => [];
}

// Listeners
sealed class ListenerState extends CustomFoodsState {
  const ListenerState();
}

final class FetchUserFoodsListenerState extends ListenerState {
  const FetchUserFoodsListenerState({required this.data});

  final List<FoodRecord> data;

  @override
  List<Object?> get props => [data];
}

final class LogSuccessState extends ListenerState {
  const LogSuccessState();

  @override
  List<Object?> get props => [];
}

// Builders
sealed class BuilderState extends CustomFoodsState {
  const BuilderState();
}

final class FetchUserFoodsBuilderState extends BuilderState {
  const FetchUserFoodsBuilderState();

  @override
  List<Object?> get props => [];
}
