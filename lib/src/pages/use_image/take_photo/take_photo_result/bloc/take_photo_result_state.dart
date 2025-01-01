part of 'take_photo_result_bloc.dart';

sealed class TakePhotoResultState extends Equatable {
  const TakePhotoResultState();
}

final class TakePhotoResultInitial extends TakePhotoResultState {
  const TakePhotoResultInitial();

  @override
  List<Object> get props => [];
}

final class FinishGeneratingResultsState extends TakePhotoResultState {
  const FinishGeneratingResultsState();

  @override
  List<Object> get props => [];
}

final class ResultsSuccessState extends TakePhotoResultState {
  const ResultsSuccessState({required this.foodItems});

  final List<FoodItemModel> foodItems;

  @override
  List<Object> get props => [foodItems];
}

final class UpdateHeaderState extends TakePhotoResultState {
  const UpdateHeaderState({required this.mealLabel, required this.timeStamp});

  final MealLabel mealLabel;
  final DateTime timeStamp;

  @override
  List<Object> get props => [mealLabel, timeStamp];
}
