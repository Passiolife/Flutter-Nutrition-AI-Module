part of 'take_photo_result_bloc.dart';

sealed class TakePhotoResultEvent extends Equatable {
  const TakePhotoResultEvent();
}

final class InitializeEvent extends TakePhotoResultEvent {
  const InitializeEvent();

  @override
  List<Object?> get props => [];
}

final class SetDefaultHeaderEvent extends TakePhotoResultEvent {
  const SetDefaultHeaderEvent();

  @override
  List<Object?> get props => [];
}

final class UpdateMealLabelEvent extends TakePhotoResultEvent {
  const UpdateMealLabelEvent({required this.mealLabel});

  final MealLabel mealLabel;

  @override
  List<Object?> get props => [mealLabel];
}

final class UpdateTimeStampEvent extends TakePhotoResultEvent {
  const UpdateTimeStampEvent({required this.timeStamp});

  final DateTime? timeStamp;

  @override
  List<Object?> get props => [timeStamp];
}

final class DoProcessEvent extends TakePhotoResultEvent {
  const DoProcessEvent({required this.images});

  final List<Uint8List>? images;

  @override
  List<Object?> get props => [images];
}

final class SelectFoodItemEvent extends TakePhotoResultEvent {
  const SelectFoodItemEvent({
    required this.index,
    required this.isSelected,
  });

  final int index;
  final bool isSelected;

  @override
  List<Object?> get props => [index, isSelected];
}

final class UpdateMacroNutrientEvent extends TakePhotoResultEvent {
  const UpdateMacroNutrientEvent();

  @override
  List<Object?> get props => [];
}

final class UpdateActionButtonsEvent extends TakePhotoResultEvent {
  const UpdateActionButtonsEvent();

  @override
  List<Object?> get props => [];
}

final class UpdateServingSizeEvent extends TakePhotoResultEvent {
  const UpdateServingSizeEvent({required this.index, required this.foodRecord});

  final int index;
  final FoodRecord foodRecord;

  @override
  List<Object?> get props => [foodRecord];
}
