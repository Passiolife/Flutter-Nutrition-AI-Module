part of 'meal_plan_bloc.dart';

sealed class MealPlanState extends Equatable {
  const MealPlanState();
}

final class MealPlanInitial extends MealPlanState {
  const MealPlanInitial();

  @override
  List<Object> get props => [];
}

final class DayUpdateSuccessState extends MealPlanState {
  const DayUpdateSuccessState({required this.day});

  final int day;

  @override
  List<Object?> get props => [day];
}

final class FetchMealPlansSuccessState extends MealPlanState {
  const FetchMealPlansSuccessState({required this.data});

  final List<PassioMealPlan> data;

  @override
  List<Object?> get props => [data];
}

final class FetchMealPlanItemsLoadingState extends MealPlanState {
  const FetchMealPlanItemsLoadingState();

  @override
  List<Object?> get props => [];
}

final class FetchMealPlanItemsSuccessState extends MealPlanState {
  const FetchMealPlanItemsSuccessState({required this.data});

  final List<PassioMealPlanItem> data;

  @override
  List<Object?> get props => [data];
}

final class LogEntireMealLoadingState extends MealPlanState {
  const LogEntireMealLoadingState();

  @override
  List<Object?> get props => [];
}

class LogSuccessState extends MealPlanState {
  const LogSuccessState({required this.createdAt});
  final int createdAt;

  @override
  List<Object?> get props => [createdAt];
}

class LogMealSuccessState extends MealPlanState {
  const LogMealSuccessState();

  @override
  List<Object?> get props => [];
}
