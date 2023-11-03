part of 'food_details_bloc.dart';

abstract class EditFoodState {}

class EditFoodInitial extends EditFoodState {}

// States for DoSliderUpdateEvent
class SliderUpdateState extends EditFoodState {
  final SliderData sliderData;

  SliderUpdateState({required this.sliderData});
}

class AlternateSuccessState extends EditFoodState {
  final FoodRecord? data;

  AlternateSuccessState({this.data});
}

class UpdateAmountEditableState extends EditFoodState {
  final bool isEditable;

  UpdateAmountEditableState({required this.isEditable});
}
