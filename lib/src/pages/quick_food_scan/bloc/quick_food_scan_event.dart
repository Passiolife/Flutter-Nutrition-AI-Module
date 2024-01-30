part of 'quick_food_scan_bloc.dart';

abstract class QuickFoodScanEvent {}

class RecognitionResultEvent extends QuickFoodScanEvent {
  final FoodCandidates foodCandidates;
  final String? displayedResult;
  final DateTime dateTime;

  RecognitionResultEvent({required this.foodCandidates, required this.displayedResult, required this.dateTime});
}

class ShowFoodDetailsViewEvent extends QuickFoodScanEvent {
  final bool isVisible;

  ShowFoodDetailsViewEvent({required this.isVisible});
}

class DoLogEvent extends QuickFoodScanEvent {
  final FoodRecord? data;

  DoLogEvent({required this.data});
}

// Event will insert the food record into the favorites of the database.
class DoFavouriteEvent extends QuickFoodScanEvent {
  final FoodRecord? data;
  final DateTime dateTime;

  DoFavouriteEvent({required this.data, required this.dateTime});
}
