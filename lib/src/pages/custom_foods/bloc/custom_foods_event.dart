part of 'custom_foods_bloc.dart';

sealed class CustomFoodsEvent extends Equatable {
  const CustomFoodsEvent();
}

final class FetchUserFoodsEvent extends CustomFoodsEvent {
  const FetchUserFoodsEvent();

  @override
  List<Object?> get props => [];
}

final class FetchSuccessEvent extends CustomFoodsEvent {
  const FetchSuccessEvent(this.data);

  final List<FoodRecord> data;

  @override
  List<Object?> get props => [data];
}

final class FetchErrorEvent extends CustomFoodsEvent {
  const FetchErrorEvent(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}

final class DeleteFoodEvent extends CustomFoodsEvent {
  const DeleteFoodEvent({required this.index});

  final int index;

  @override
  List<Object?> get props => [index];
}

final class DeleteUserFoodRecordSuccessEvent extends CustomFoodsEvent {
  const DeleteUserFoodRecordSuccessEvent();

  @override
  List<Object?> get props => [];
}

final class DeleteUserFoodRecordErrorEvent extends CustomFoodsEvent {
  const DeleteUserFoodRecordErrorEvent({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}