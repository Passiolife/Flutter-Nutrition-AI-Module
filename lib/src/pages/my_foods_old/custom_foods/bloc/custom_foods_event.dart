part of 'custom_foods_bloc.dart';

sealed class CustomFoodsEvent extends Equatable {
  const CustomFoodsEvent();
}

final class FetchUserFoodsEvent extends CustomFoodsEvent {
  const FetchUserFoodsEvent();

  @override
  List<Object?> get props => [];
}

final class DoFoodLogEvent extends CustomFoodsEvent {
  const DoFoodLogEvent({required this.foodRecord});

  final FoodRecord foodRecord;

  @override
  List<Object?> get props => [foodRecord];
}

final class DoUpdateUserFoodEvent extends CustomFoodsEvent {
  const DoUpdateUserFoodEvent({required this.foodRecord});

  final FoodRecord foodRecord;

  @override
  List<Object?> get props => [foodRecord];
}

final class DoDeleteUserFoodEvent extends CustomFoodsEvent {
  const DoDeleteUserFoodEvent({required this.foodRecord});

  final FoodRecord foodRecord;

  @override
  List<Object?> get props => [foodRecord];
}
