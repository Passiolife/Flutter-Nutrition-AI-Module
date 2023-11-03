part of 'multi_food_scan_bloc.dart';

abstract class MultiFoodScanEvent {}

class RecognitionResultEvent extends MultiFoodScanEvent {
  final FoodCandidates foodCandidates;
  final List<FoodRecord?> list;
  final List<FoodRecord?> removedList;
  final DateTime dateTime;

  RecognitionResultEvent({required this.foodCandidates, required this.list, required this.removedList, required this.dateTime});
}

class ShowFoodDetailsViewEvent extends MultiFoodScanEvent {
  final bool isVisible;
  final int index;

  ShowFoodDetailsViewEvent({required this.isVisible, required this.index});
}

class DoAddAllEvent extends MultiFoodScanEvent {
  final List<FoodRecord?> data;
  final DateTime dateTime;

  DoAddAllEvent({required this.data, required this.dateTime});
}

class DoNewRecipeEvent extends MultiFoodScanEvent {
  final String? name;
  final List<FoodRecord?> data;
  final DateTime dateTime;

  DoNewRecipeEvent({required this.name, required this.data, required this.dateTime});
}

class DoClearAllEvent extends MultiFoodScanEvent {

}