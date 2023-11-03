part of 'food_details_bloc.dart';

abstract class EditFoodEvent {}

class DoUpdateUnitKeepWeightEvent extends EditFoodEvent {
  final FoodRecord? data;
  final String selectedUnitName;

  DoUpdateUnitKeepWeightEvent({required this.data, required this.selectedUnitName});
}

class DoUpdateQuantityEvent extends EditFoodEvent {
  final FoodRecord? data;
  final double updatedQuantity;
  final bool shouldReset;

  DoUpdateQuantityEvent({required this.data, required this.updatedQuantity, required this.shouldReset});
}

class DoUpdateServingSizeEvent extends EditFoodEvent {
  final FoodRecord? data;
  final String? updatedUnitName;
  final double? updatedQuantity;

  DoUpdateServingSizeEvent({required this.data, required this.updatedUnitName, required this.updatedQuantity});
}

class DoSliderUpdateEvent extends EditFoodEvent {
  final FoodRecord? data;
  final bool shouldReset;

  DoSliderUpdateEvent({required this.data, required this.shouldReset});
}

class DoAlternateEvent extends EditFoodEvent {
  final PassioID? passioID;

  DoAlternateEvent({required this.passioID});
}

class DoUpdateAmountEditableEvent extends EditFoodEvent {
  bool isEditable;

  DoUpdateAmountEditableEvent({required this.isEditable});
}
