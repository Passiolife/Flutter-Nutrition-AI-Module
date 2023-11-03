part of 'dashboard_bloc.dart';

abstract class DashboardEvent {}

class GetFoodRecordsEvent extends DashboardEvent {
  final DateTime dateTime;

  GetFoodRecordsEvent({required this.dateTime});
}

class RefreshFoodRecordEvent extends DashboardEvent {}

class DeleteFoodRecordEvent extends DashboardEvent {
  final FoodRecord? data;

  DeleteFoodRecordEvent({required this.data});
}

class DoFoodInsertEvent extends DashboardEvent {
  final PassioIDAndName? data;
  final DateTime dateTime;

  DoFoodInsertEvent({required this.data, required this.dateTime});
}

// Event will update the food record in DB.
class DoFoodUpdateEvent extends DashboardEvent {
  final FoodRecord? data;

  DoFoodUpdateEvent({required this.data});
}

// Event will insert the food record into the favorites of the database.
class DoFavouriteEvent extends DashboardEvent {
  final FoodRecord? data;
  final DateTime dateTime;

  DoFavouriteEvent({required this.data, required this.dateTime});
}

/// Event will update the list based on the current tab selected.
class DoTabChangeEvent extends DashboardEvent {
  final String tab;

  DoTabChangeEvent({required this.tab});
}
