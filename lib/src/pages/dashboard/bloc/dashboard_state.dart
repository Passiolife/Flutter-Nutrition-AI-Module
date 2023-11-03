part of 'dashboard_bloc.dart';

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class GetFoodRecordSuccessState extends DashboardState {
  final List<FoodRecord?> data;

  GetFoodRecordSuccessState({required this.data});
}

class GetFoodRecordFailureState extends DashboardState {
  final String message;

  GetFoodRecordFailureState({required this.message});
}

class RefreshFoodLogState extends DashboardState {}

/// States for [DeleteFoodRecordEvent]
class DeleteRecordSuccessState extends DashboardState {}

class DeleteRecordFailureState extends DashboardState {
  final String message;

  DeleteRecordFailureState({required this.message});
}

/// states for DoFoodInsertEvent
class FoodInsertSuccessState extends DashboardState {}

class FoodInsertFailureState extends DashboardState {
  final String message;

  FoodInsertFailureState({required this.message});
}

// states for DoFoodUpdateEvent
class FoodUpdateSuccessState extends DashboardState {}

class FoodUpdateFailureState extends DashboardState {
  final String message;

  FoodUpdateFailureState({required this.message});
}

// States for DoFavouriteEvent
class FavoriteSuccessState extends DashboardState {}

class FavoriteFailureState extends DashboardState {
  final String message;

  FavoriteFailureState({required this.message});
}

/// States for [DoTabChangeEvent]
class TabChangedState extends DashboardState {
  final String tab;

  TabChangedState({required this.tab});
}
