part of 'meal_plan_bloc.dart';

sealed class MealPlanEvent extends Equatable {
  const MealPlanEvent();
}

final class DoDayUpdateEvent extends MealPlanEvent {
  final int day;

  const DoDayUpdateEvent({required this.day});

  @override
  List<Object?> get props => [day];
}

final class DoFetchMealPlansEvent extends MealPlanEvent {
  const DoFetchMealPlansEvent();

  @override
  List<Object?> get props => [];
}

final class DoFetchMealPlanForDayEvent extends MealPlanEvent {
  const DoFetchMealPlanForDayEvent(
      {required this.day, required this.mealPlanLabel});

  final int day;
  final String mealPlanLabel;

  @override
  List<Object?> get props => [day, mealPlanLabel];
}

final class DoLogEntireMealEvent extends MealPlanEvent {
  const DoLogEntireMealEvent({required this.data, this.mealTime});

  final List<PassioFoodDataInfo>? data;
  final PassioMealTime? mealTime;

  @override
  List<Object?> get props => [data, mealTime];
}

class DoLogEvent extends MealPlanEvent {
  const DoLogEvent({this.data, this.mealTime});

  final PassioFoodDataInfo? data;
  final PassioMealTime? mealTime;

  @override
  List<Object?> get props => [data];
}
