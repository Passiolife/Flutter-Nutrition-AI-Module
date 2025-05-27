part of 'custom_foods_bloc.dart';

sealed class CustomFoodsState  extends Equatable {
  const CustomFoodsState();
}

final class InitialState extends CustomFoodsState {
  const InitialState();

  @override
  List<Object?> get props => [];
}

final class FetchSuccessState extends CustomFoodsState {
  const FetchSuccessState({required this.data});

  final List<FoodRecord> data;

  @override
  List<Object?> get props => [data];
}

final class FetchErrorState extends CustomFoodsState {
  const FetchErrorState({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}

final class DeleteUserFoodRecordSuccessState extends CustomFoodsState {
  const DeleteUserFoodRecordSuccessState();

  @override
  List<Object?> get props => [];
}

final class DeleteUserFoodRecordErrorState extends CustomFoodsState {
  const DeleteUserFoodRecordErrorState({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}

